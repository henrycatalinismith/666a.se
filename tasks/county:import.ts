import _ from 'lodash'

import counties from '../data/county.json'
import { createCounty } from '../lib/county'
;(async () => {
  for (const county of _.sortBy(counties, 'name')) {
    await createCounty({
      name: county.name,
      code: county.code,
      slug: county.slug,
    })
  }
})()
