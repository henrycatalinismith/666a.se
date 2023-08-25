import companies from '../data/company.json'
import { createCompany } from '../lib/company'
;(async () => {
  companies.forEach((company) => {
    createCompany({
      name: company.name,
      code: company.id,
    })
  })
})()
