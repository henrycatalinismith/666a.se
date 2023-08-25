import { db } from '../lib/database'
;(async () => {
  const counties = await db.selectFrom('county').selectAll().execute()
  counties.forEach((county) => {
    console.log(county.id)
    console.log(county.name)
    console.log(county.slug)
    console.log(county.created)
  })
})()
