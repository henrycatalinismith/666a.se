import types from 'data/type.json'
import prisma from 'lib/database'
import slugify from 'slugify'
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
