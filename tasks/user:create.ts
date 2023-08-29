import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcrypt'
const prisma = new PrismaClient()
;(async () => {
  await prisma.user.create({
    data: {
      name: process.argv[2]!,
      email: process.argv[3],
      password: await bcrypt.hash(process.argv[4], 10),
    },
  })
})()
