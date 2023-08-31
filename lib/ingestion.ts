import { Chunk, County, Stub } from '@prisma/client'
import * as puppeteer from 'puppeteer'

import prisma from './database'

export async function scanCounty(county: County): Promise<Scan> {
  const ongoingScan = await prisma.scan.findFirst({
    where: {
      countyId: county.id,
      completed: undefined,
    },
  })

  if (ongoingScan) {
    console.log('ongoing')
    return ongoingScan
  }

  console.log('new scan')

  // determine highest already-scanned date for the county : date H
  // send county-wide search request in ascending date order beginning date H

  const now = new Date()
  const scan = await prisma.scan.create({
    data: {
      countyId: county.id,
      chunkCount: 1,
      completed: null,
      created: now,
      updated: now,
    },
  })

  const chunk = await prisma.chunk.create({
    data: {
      scanId: scan.id,
      startDate: null,
      stubCount: null,
      created: now,
      updated: now,
    },
  })

  await ingestChunk(chunk)

  const { hitCount } = await prisma.chunk.findFirstOrThrow({
    where: { id: chunk.id },
  })
  console.log(hitCount)

  return scan
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export async function ingestChunk(chunk: Chunk): Promise<Stub[]> {
  console.log(`ingest : ${chunk.id}`)
  const scan = await prisma.scan.findFirstOrThrow({
    where: { id: chunk.scanId },
  })

  const county = await prisma.county.findFirstOrThrow({
    where: { id: scan.countyId },
  })

  const browser = await puppeteer.launch({ headless: 'new' })
  const page = await browser.newPage()
  const host = 'www.av.se'
  const path = '/om-oss/sok-i-arbetsmiljoverkets-diarium/'
  const query = new URLSearchParams({
    SelectedCounty: county.code,
    sortDirection: 'Desc',
    sortOrder: 'Dokumentdatum',
  }).toString()
  const url = `https://${host}${path}?${query}`
  console.log(url)
  await page.goto(url)

  const hitCount = await page.$eval('.hit-count', (e) => (e as any).innerText)

  const rows = await page.evaluate(() => {
    return Array.from(
      document.querySelectorAll('#handling-results tbody tr')
    ).map((row) => {
      const document_code = row
        .querySelector('td:nth-child(1)')!
        .innerHTML.trim()
      const case_name = row.querySelector('td:nth-child(2) a')!.innerHTML.trim()
      const document_type = row
        .querySelector('td:nth-child(3)')!
        .innerHTML.trim()
      const filed = row.querySelector('td:nth-child(4)')!.innerHTML.trim()
      const organization = row
        .querySelector('td:nth-child(5)')!
        .innerHTML.trim()
      return {
        document_code,
        case_name,
        document_type,
        filed,
        organization,
      }
    })
  })

  console.log('Rows: ' + rows.length)
  console.log(rows)
  const stubs = []
  for (const row of rows) {
    console.log(row)
    const document = await prisma.document.findFirst({
      where: { code: row.document_code },
    })
    if (document) {
      continue
    }

    const now = new Date()
    const stub = await prisma.stub.create({
      data: {
        chunkId: chunk.id,
        document_code: row.document_code,
        case_name: row.case_name,
        document_type: row.document_type,
        filed: new Date(row.filed),
        organization: row.organization,
        created: now,
        updated: now,
        ingested: null,
      },
    })
    stubs.push(stub)
  }
  console.log('Stubs: ' + stubs.length)

  const startDate = chunk.startDate ?? stubs[0].filed

  await prisma.chunk.update({
    where: { id: chunk.id },
    data: {
      hitCount,
      startDate,
      stubCount: stubs.length,
      ingested: new Date(),
      updated: new Date(),
    },
  })

  const uningestedSiblings = await prisma.chunk.count({
    where: {
      scanId: scan.id,
      ingested: { not: null },
    },
  })
  if (uningestedSiblings === 0) {
    await prisma.scan.update({
      where: { id: scan.id },
      data: { completed: new Date(), updated: new Date() },
    })
  }

  return stubs
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export async function ingestStub(stub: Stub): Promise<void> {
  // send request
  // create document from response
  // mark stub as ingested
}
