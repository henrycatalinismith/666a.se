import { PrismaClient } from '@prisma/client'
import {
  PrismaClientOptions,
  DefaultArgs,
} from '@prisma/client/runtime/library'

let prisma

if (process.env.NODE_ENV === 'production') {
  prisma = new PrismaClient()
} else {
  if (!(global as any).prisma) {
    ;(global as any).prisma = new PrismaClient()
  }
  prisma = (global as any).prisma
}

export type Transaction = Omit<
  PrismaClient<PrismaClientOptions, never, DefaultArgs>,
  '$connect' | '$disconnect' | '$on' | '$transaction' | '$use' | '$extends'
>

export default prisma as PrismaClient
