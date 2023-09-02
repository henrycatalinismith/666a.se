import prisma from '../lib/database'
;(async () => {
  await prisma.status.create({
    data: {
      name: 'Avslutat',
      slug: 'concluded',
    },
  })

  await prisma.status.create({
    data: {
      name: 'Pågående',
      slug: 'ongoing',
    },
  })
})()
