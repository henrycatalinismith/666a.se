import * as puppeteer from 'puppeteer'

import { fetchAllCompanies } from '../lib/company'
import { scrapeCompany } from '../lib/scraper'
;(async () => {
  const browser: any = await puppeteer.launch({ headless: 'new' })

  const companies = await fetchAllCompanies()
  for (const company of companies) {
    console.log(`${company.code}: ${company.name}`)
    await scrapeCompany({ code: company.code, browser })
  }
})()
