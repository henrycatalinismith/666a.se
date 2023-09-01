import { Chunk, County, Scan, Stub } from '@prisma/client'

import { createChunk, updateChunk } from './chunk'
import prisma from './database'
import { searchDiarium } from './diarium'
import { createScan, findOngoingScan } from './scan'
import { createStubs } from './stub'

export async function scanCounty(county: County): Promise<Scan> {
  const ongoingScan = await findOngoingScan(county)
  if (ongoingScan) {
    return ongoingScan
  }

  // TODO: determine highest already-scanned date for the county : date H
  // send county-wide search request in ascending date order beginning date H

  const scan = await createScan(county)
  const pendingChunk = await createChunk(scan)
  const ingestedChunk = await ingestChunk(pendingChunk)
  console.log(ingestedChunk.hitCount)

  // TODO: bulk create other chunks for scan based on projection from
  // ingestedChunk.hitCount

  return scan
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export async function ingestChunk(chunk: Chunk): Promise<Chunk> {
  const scan = await prisma.scan.findFirstOrThrow({
    where: { id: chunk.scanId },
  })

  const county = await prisma.county.findFirstOrThrow({
    where: { id: scan.countyId },
  })

  console.log(`[ingestChunk]: ${chunk.id} ${county.name}`)

  const result = await searchDiarium({
    SelectedCounty: county.code,
    sortDirection: 'Desc',
    sortOrder: 'Dokumentdatum',
  })

  console.log(
    `[ingestChunk]: ${chunk.id} ${result.rows.length} ${result.hitCount}`
  )

  const stubs = await createStubs(chunk, result)
  const startDate = chunk.startDate ?? stubs[0].filed
  return await updateChunk(chunk.id, {
    hitCount: result.hitCount,
    startDate,
    stubCount: stubs.length,
    ingested: new Date(),
  })
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export async function ingestStub(stub: Stub): Promise<void> {
  // send request
  // create document from response
  // mark stub as ingested
}
