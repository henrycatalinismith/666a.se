import counties from '../data/county.json'
import { createCounty } from '../lib/county'
;(async () => {
  counties.forEach((county) => {
    createCounty({
      name: county.name,
      code: county.code,
      slug: county.slug,
    })
  })
})()
