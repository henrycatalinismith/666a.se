import { Chunk, Stub } from '@prisma/client'

import prisma from './database'
import { DiariumSearchResult } from './diarium'

export async function createStubs(
  chunk: Chunk,
  searchResult: DiariumSearchResult
): Promise<Stub[]> {
  // When turning a search result into stubs, it's possible some of the result
  // rows may correspond to already-ingested documents. Creating a stub when a
  // document has already been ingested means wasting a request reingesting the
  // same document twice. Filtering out existing documents here avoids this.
  const documents = await prisma.document.findMany({
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

  await prisma.stub.createMany({
    data: newDocuments.map((row, index) => ({
      chunkId: chunk.id,
      index,
      documentCode: row.documentCode,
      caseName: row.caseName,
      documentType: row.documentType,
      filed: new Date(row.filed),
      organization: row.organization,
      created: now,
      updated: now,
      ingested: null,
    })),
  })

  return await prisma.stub.findMany({
    where: {
      chunkId: chunk.id,
      index: 0,
    },
    orderBy: { index: 'asc' },
  })
}
