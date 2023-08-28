import _ from 'lodash'

import municipalities from '../data/municipality.json'
import { createMunicipality } from '../lib/municipality'
;(async () => {
  for (const municipality of _.sortBy(municipalities, 'municipality')) {
    await createMunicipality({
      name: municipality.municipality,
      code: municipality.code,
      county: municipality.county,
    })
  }
})()
