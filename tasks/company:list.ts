import { db } from '../lib/database'
;(async () => {
  const companies = await db.selectFrom('company').selectAll().execute()
  companies.forEach((company) => {
    console.log(company.id)
    console.log(company.name)
    console.log(company.number)
    console.log(company.created)
  })
})()
