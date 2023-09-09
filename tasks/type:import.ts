import slugify from 'slugify'

import types from '../data/type.json'
import prisma from '../lib/database'
;(async () => {
  for (const t of types) {
    await prisma.type.create({
      data: {
        name: t,
        slug: slugify(t, { lower: true }),
      },
    })
  }
})()
