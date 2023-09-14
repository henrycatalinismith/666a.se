import { ChunkStatus, StubStatus } from '@prisma/client'
import _ from 'lodash'

import prisma from '../lib/database'
import { searchDiarium } from '../lib/diarium'
;(async () => {
  await prisma.$transaction(
    async (tx) => {
      const date = new Date(process.argv[2])

      const day = await tx.day.findFirstOrThrow({
        where: { date },
        include: { chunks: true },
      })

      console.log(day)

      const result = await searchDiarium({
        FromDate: date.toISOString().substring(0, 10),
        ToDate: date.toISOString().substring(0, 10),
      })

      if (day.chunks.length > 0) {
        console.log(day.chunks.length)
        console.log(result.hitCount)
        process.exit(0)
      }

      const fullResult = result.hitCount.match(/^(\d+) träffar$/)
      const stubsPerChunk = 10
      let targetStubCount = 0
      if (fullResult) {
        targetStubCount = parseInt(fullResult[1], 10)
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
          status:
            result.rows.length > 0 && newDocuments.length > 0
              ? ChunkStatus.ONGOING
              : ChunkStatus.SUCCESS,
          dayId: day.id,
          page: 1,
          stubCount: result.rows.length,
          newCount: newDocuments.length,
          hitCount: result.hitCount,
        },
      })

      const firstStubs = await tx.stub.createMany({
        data: newDocuments.map((row, index) => ({
          chunkId: firstChunk.id,
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
          dayId: day.id,
          page: index + 2,
          stubCount: null,
        })),
      })

      console.log(pendingChunks.count)
    },
    {
      timeout: 15000,
    }
  )
  process.exit(0)
})()
