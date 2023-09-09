import companies from 'data/company.json'
import prisma from 'lib/database'
import _ from 'lodash'
import slugify from 'slugify'
;(async () => {
  for (const company of _.sortBy(companies, 'name')) {
    await prisma.company.create({
      data: {
        name: company.name,
        slug: slugify(company.name, {
          lower: true,
        }),
        code: company.id,
      },
    })
  }
})()
