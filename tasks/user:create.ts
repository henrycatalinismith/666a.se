import bcrypt from 'bcrypt'
import prisma from 'lib/database'
;(async () => {
  await prisma.user.create({
    data: {
      name: process.argv[2]!,
      email: process.argv[3],
      password: await bcrypt.hash(process.argv[4], 10),
    },
  })
})()
