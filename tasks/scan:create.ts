import { ChunkStatus, ScanStatus, StubStatus } from '@prisma/client'
import _ from 'lodash'

import prisma from '../lib/database'
import { searchDiarium } from '../lib/ingestion'
;(async () => {
  await prisma.$transaction(
    async (tx) => {
      const incompleteScan = await tx.scan.findFirst({
        where: {
          status: { in: [ScanStatus.PENDING, ScanStatus.ONGOING] },
        },
      })
      if (incompleteScan) {
        throw new Error('no')
      }

      const date = new Date('2023-09-12')

      const scan = await tx.scan.create({
        data: {
          date,
          status: ScanStatus.ONGOING,
          chunkCount: 0,
        },
      })

      const result = await searchDiarium({
        FromDate: date.toISOString().substring(0, 10),
        ToDate: date.toISOString().substring(0, 10),
      })

      const fullResult = result.hitCount.match(/^(\d+) träffar$/)
      const stubsPerChunk = 10
      let targetStubCount = 0
      if (fullResult) {
        targetStubCount = parseInt(fullResult[1], 10) - stubsPerChunk
      }
      const targetChunkCount = targetStubCount / stubsPerChunk

      const documents = await tx.document.findMany({
        where: {
          code: {
            in: result.rows.map((r) => r.documentCode),
          },
        },
      })
      const documentCodes = documents.map((d) => d.code)
      const newDocuments = result.rows.filter((row) => {
        return !documentCodes.includes(row.documentCode)
      })

      const now = new Date()

      const firstChunk = await tx.chunk.create({
        data: {
          status: ChunkStatus.SUCCESS,
          scanId: scan.id,
          startDate: date,
          page: 1,
          hitCount: result.hitCount,
        },
      })

      await tx.scan.update({
        where: { id: scan.id },
        data: { chunkCount: { increment: 1 } },
      })

      const firstStubs = await tx.stub.createMany({
        data: newDocuments.map((row, index) => ({
          chunkId: firstChunk.id,
          scanId: firstChunk.scanId,
          index,
          status: StubStatus.PENDING,
          caseName: row.caseName,
          documentCode: row.documentCode,
          documentDate: new Date(row.documentDate),
          documentType: row.documentType,
          companyName: row.companyName,
          created: now,
          updated: now,
        })),
      })

      await tx.chunk.update({
        where: { id: firstChunk.id },
        data: { stubCount: { increment: firstStubs.count } },
      })

      const pendingChunks = await tx.chunk.createMany({
        data: _.times(targetChunkCount, (index) => ({
          status: ChunkStatus.PENDING,
          scanId: scan.id,
          startDate: scan.startDate,
          page: index + 2,
          stubCount: null,
        })),
      })

      await tx.scan.update({
        where: { id: scan.id },
        data: { chunkCount: { increment: pendingChunks.count } },
      })

      console.log(result)
    },
    {
      timeout: 15000,
    }
  )
  process.exit(0)
})()
