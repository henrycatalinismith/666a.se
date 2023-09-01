import _ from 'lodash'
import * as puppeteer from 'puppeteer'

export type DiariumSearchParameter =
  | 'id'
  | 'sortDirection'
  | 'sortOrder'
  | 'OrganisationNumber'
  | 'OnlyActive'
  | 'SelectedCounty'
  | 'ShowToolbar'
  | 'page'

export type DiariumSearchQuery = Partial<Record<DiariumSearchParameter, any>>

export type DiariumSearchResult = {
  hitCount: string
  rows: {
    caseName: string
    documentCode: string
    documentType: string
    filed: string
    organization: string
  }[]
}

export async function searchDiarium(
  query: DiariumSearchQuery
): Promise<DiariumSearchResult> {
  const browser = await puppeteer.launch({ headless: 'new' })
  const page = await browser.newPage()
  const url = new URL(
    '/om-oss/sok-i-arbetsmiljoverkets-diarium/',
    'https://www.av.se/'
  )
  _.mapValues(query, (v, k) => {
    url.searchParams.set(k, v)
  })
  await page.goto(url.toString())

  const result: DiariumSearchResult = {
    hitCount: '',
    rows: [],
  }

  result.hitCount = await page.$eval('.hit-count', (e) => (e as any).innerText)
  result.rows = await page.evaluate(() => {
    return Array.from(
      document.querySelectorAll('#handling-results tbody tr')
    ).map((row) => {
      return {
        documentCode: row.querySelector('td:nth-child(1)')!.innerHTML.trim(),
        caseName: row.querySelector('td:nth-child(2) a')!.innerHTML.trim(),
        documentType: row.querySelector('td:nth-child(3)')!.innerHTML.trim(),
        filed: row.querySelector('td:nth-child(4)')!.innerHTML.trim(),
        organization: row.querySelector('td:nth-child(5)')!.innerHTML.trim(),
      }
    })
  })

  return result
}
