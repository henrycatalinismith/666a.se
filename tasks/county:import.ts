import { PrismaClient } from '@prisma/client'
import _ from 'lodash'

import counties from '../data/county.json'
const prisma = new PrismaClient()

;(async () => {
  for (const county of _.sortBy(counties, 'name')) {
    await prisma.county.create({
      data: {
        name: county.name,
        code: county.code,
        slug: county.slug,
      },
    })
  }
})()
