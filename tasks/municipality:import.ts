import _ from 'lodash'
import slugify from 'slugify'

import municipalities from '../data/municipality.json'
import prisma from '../lib/database'
;(async () => {
  for (const municipality of _.sortBy(municipalities, 'municipality')) {
    const county = await prisma.county.findFirstOrThrow({
      where: {
        slug: slugify(municipality.county, { lower: true }),
      },
    })
    await prisma.municipality.create({
      data: {
        name: municipality.municipality,
        code: municipality.code,
        slug:
          municipality.municipality === 'Håbo'
            ? 'haabo'
            : slugify(municipality.municipality, { lower: true }),
        countyId: county.id,
      },
    })
  }
})()
