import _ from 'lodash'
import * as puppeteer from 'puppeteer'

export type DiariumDocument = {
  caseCode: string
  caseStatus: string
  caseTopic: string
  documentCode: string
  documentDate: string
  documentType: string
  documentDirection: string
  companyName: string | null
  companyCode: string | null
  workplaceName: string | null
  workplaceCode: string | null
  countyName: string | null
  countyCode: string | null
  municipalityName: string | null
  municipalityCode: string | null
}

type DiariumSearchParameter =
  | 'id'
  | 'sortDirection'
  | 'sortOrder'
  | 'OrganisationNumber'
  | 'OnlyActive'
  | 'SelectedCounty'
  | 'ShowToolbar'
  | 'FromDate'
  | 'ToDate'
  | 'page'

type DiariumSearchQuery = Partial<Record<DiariumSearchParameter, any>>

type DiariumSearchResult = {
  hitCount: string
  rows: {
    caseName: string
    companyName: string
    documentCode: string
    documentDate: string
    documentType: string
  }[]
}

async function launchBrowser(): Promise<puppeteer.Browser> {
  if (!(global as any).browser) {
    ;(global as any).browser = await puppeteer.launch({ headless: 'new' })
  }
  return (global as any).browser
}

export async function searchDiarium(
  query: DiariumSearchQuery
): Promise<DiariumSearchResult> {
  const browser = await launchBrowser()
  const page = await browser.newPage()
  const url = new URL(
    '/om-oss/sok-i-arbetsmiljoverkets-diarium/',
    'https://www.av.se/'
  )
  _.mapValues(query, (v, k) => {
    url.searchParams.set(k, v)
  })
  console.log(url.toString())
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
        documentDate: row.querySelector('td:nth-child(4)')!.innerHTML.trim(),
        companyName: row.querySelector('td:nth-child(5)')!.innerHTML.trim(),
      }
    })
  })

  return result
}

export async function fetchDocument(code: string): Promise<DiariumDocument> {
  const browser = await launchBrowser()
  const page = await browser.newPage()
  const url = new URL(
    '/om-oss/sok-i-arbetsmiljoverkets-diarium/',
    'https://www.av.se/'
  )
  url.searchParams.set('id', code)
  await page.goto(url.toString())

  const d = await page.evaluate(() => {
    const dd: HTMLElement[] = Array.from(document.querySelectorAll('dd'))
    const organisationMatches = dd[5].innerHTML.match(
      /^(.+?) \((\d{6}-\d{4})\)/
    )
    const organisationSaknas = dd[5].innerHTML.trim() === 'Saknas'
    const workplaceNameSaknas = dd[7].innerHTML.trim() === 'Saknas'
    const workplaceCodeSaknas = dd[7].innerHTML.trim() === 'Saknas'
    const countySaknas = dd[8].innerHTML.trim() === 'Saknas'
    const municipalitySaknas = dd[9].innerHTML.trim() === 'Saknas'

    return {
      caseCode: dd[0].innerHTML,
      caseStatus: dd[11].innerHTML,
      caseTopic: dd[2].innerHTML,
      documentCode: dd[1].innerHTML,
      documentDate: dd[10].innerHTML,
      documentType: dd[3].innerHTML.trim(),
      documentDirection: dd[4].innerHTML,
      companyName: organisationSaknas ? null : organisationMatches![1],
      companyCode: organisationSaknas ? null : organisationMatches![2],
      workplaceName: workplaceNameSaknas ? null : dd[7].innerHTML.trim(),
      workplaceCode: workplaceCodeSaknas ? null : dd[6].innerHTML.trim(),
      countyName: countySaknas
        ? null
        : dd[8].innerHTML.match(/^(.+?) \((\d\d)\)/)![1],
      countyCode: countySaknas
        ? null
        : dd[8].innerHTML.match(/^(.+?) \((\d\d)\)/)![2],
      municipalityName: municipalitySaknas
        ? null
        : dd[9].innerHTML.match(/^(.+?) \((\d{4})\)/)![1],
      municipalityCode: municipalitySaknas
        ? null
        : dd[9].innerHTML.match(/^(.+?) \((\d{4})\)/)![2],
    }
  })

  return d
}
