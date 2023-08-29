import { PrismaClient } from '@prisma/client'
import _ from 'lodash'
import slugify from 'slugify'

import companies from '../data/company.json'
const prisma = new PrismaClient()

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
