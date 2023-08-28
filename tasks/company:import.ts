import _ from 'lodash'

import companies from '../data/company.json'
import { createCompany } from '../lib/company'
;(async () => {
  for (const company of _.sortBy(companies, 'name')) {
    await createCompany({
      name: company.name,
      code: company.id,
    })
  }
})()
