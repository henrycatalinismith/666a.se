import municipalities from '../data/municipality.json'
import { createMunicipality } from '../lib/municipality'
;(async () => {
  municipalities.forEach((municipality) => {
    createMunicipality({
      name: municipality.municipality,
      code: municipality.code,
      county: municipality.county,
    })
  })
})()
