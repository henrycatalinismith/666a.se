import { Stub, StubStatus } from '@prisma/client'

import { Transaction } from './database'
import { DiariumSearchResult } from './diarium'

export async function createStubs(
  chunkId: string,
  searchResult: DiariumSearchResult,
  tx: Transaction
): Promise<Stub[]> {
  const chunk = await tx.chunk.findFirstOrThrow({ where: { id: chunkId } })

  // When turning a search result into stubs, it's possible some of the result
  // rows may correspond to already-ingested documents. Creating a stub when a
  // document has already been ingested means wasting a request reingesting the
  // same document twice. Filtering out existing documents here avoids this.
  const documents = await tx.document.findMany({
    where: {
      code: {
        in: searchResult.rows.map((r) => r.documentCode),
      },
    },
  })
  const documentCodes = documents.map((d) => d.code)
  const newDocuments = searchResult.rows.filter((row) => {
    return !documentCodes.includes(row.documentCode)
  })

  const now = new Date()

  await tx.stub.createMany({
    data: newDocuments.map((row, index) => ({
      chunkId: chunk.id,
      scanId: chunk.scanId,
      countyId: chunk.countyId,
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

  // TODO: update chunk.stubCount

  return await tx.stub.findMany({
    where: {
      chunkId: chunk.id,
      index: 0,
    },
    orderBy: { index: 'asc' },
  })
}
