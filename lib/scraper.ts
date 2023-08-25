import * as _ from 'lodash'
import * as puppeteer from 'puppeteer'
import { Browser } from 'puppeteer-core'

import {
  filterOutExistingDocumentCodes,
  importScrapedDocument,
} from './document'

export interface DocumentScrapeResult {
  code: string
  topic: string
  type: string
  direction: string
  company: string
  cfar: string
  workplace: string
  county: string
  municipality: string
  filed: string
  status: string
}

export interface SearchScrapeResult {
  total: number
  documents: {
    code: string
    topic: string
    type: string
    filed: string
  }[]
  pageNumber: number
  pageCount: number
}

export async function scrapeDocument({
  code,
  browser,
}: {
  code: string
  browser: Browser
}): Promise<DocumentScrapeResult> {
  const page = await browser.newPage()
  const host = 'www.av.se'
  const path = '/om-oss/sok-i-arbetsmiljoverkets-diarium/'
  const query = new URLSearchParams({
    id: code,
  }).toString()

  const url = `https://${host}${path}?${query}`

  await page.goto(url)

  const d = await page.evaluate(() => {
    const dd: HTMLElement[] = Array.from(document.querySelectorAll('dd'))
    return {
      code: dd[1].innerHTML,
      topic: dd[2].innerHTML,
      type: dd[3].innerHTML,
      direction: dd[4].innerHTML,
      company: dd[5].innerHTML.match(/(\d{6}-\d{4})/)![1],
      cfar: dd[6].innerHTML,
      workplace: dd[7].innerHTML,
      county: dd[8].innerHTML,
      municipality: dd[9].innerHTML,
      filed: dd[10].innerHTML,
      status: dd[11].innerHTML,
    }
  })

  return d
}

export async function searchCompany({
  code,
  browser,
  pageNumber = 1,
}: {
  code: string
  pageNumber?: number
  browser: Browser
}): Promise<SearchScrapeResult> {
  console.log(`Search: ${code} (${pageNumber})`)
  const page = await browser.newPage()
  const host = 'www.av.se'
  const path = '/om-oss/sok-i-arbetsmiljoverkets-diarium/'
  const query = new URLSearchParams({
    page: pageNumber.toString(),
    sortDirection: 'Desc',
    sortOrder: 'Dokumentdatum',
    OrganisationNumber: code,
    OnlyActive: 'false',
  }).toString()

  const url = `https://${host}${path}?${query}`

  await page.goto(url)

  const total = parseInt(
    await page.$eval('.hit-count', (e) => (e as any).innerText),
    10
  )
  const rows = await page.evaluate(() => {
    return Array.from(
      document.querySelectorAll('#handling-results tbody tr')
    ).map((row) => {
      const code = row.querySelector('td:nth-child(1)')!.innerHTML
      const topic = row.querySelector('td:nth-child(2) a')!.innerHTML
      const type = row.querySelector('td:nth-child(3)')!.innerHTML
      const filed = row.querySelector('td:nth-child(4)')!.innerHTML
      return { code, topic, type, filed }
    })
  })

  const pageCount = await page.evaluate(() => {
    return document.querySelectorAll(
      '.pagination li:not(.PagedList-skipToFirst):not(.PagedList-skipToPrevious):not(.PagedList-skipToNext):not(.PagedList-skipToLast'
    ).length
  })

  return {
    total,
    documents: rows,
    pageNumber,
    pageCount: pageCount,
  }
}

export async function scrapeCompany({
  code,
  browser,
}: {
  code: string
  browser: Browser
}): Promise<void> {
  let pageNumber = 1
  let newCodes = []

  console.log(code)

  do {
    const result = await searchCompany({ code, browser, pageNumber })
    const codes = _.map(result.documents, 'code')
    newCodes = await filterOutExistingDocumentCodes(codes)
    console.log(newCodes)

    for (const c of newCodes) {
      console.log(c)
      const document = await scrapeDocument({ code: c, browser })
      importScrapedDocument(document)
    }

    pageNumber += 1
  } while (newCodes.length > 0)
}
