import prisma from '../lib/database'
;(async () => {
  const [, , email, slug] = process.argv

  const user = await prisma.user.findFirstOrThrow({
    where: {
      email,
    },
  })

  const company = await prisma.company.findFirstOrThrow({
    where: {
      slug,
    },
  })

  const sub = await prisma.subscription.create({
    data: { userId: user.id, targetType: 'Company', targetId: company.id },
  })
  console.log(sub)
})()
