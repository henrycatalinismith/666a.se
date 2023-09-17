import { RoleName } from '@prisma/client'
import bcrypt from 'bcrypt'
import { NextResponse } from 'next/server'

import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'

export async function POST(request: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const { name, email, password } = await request.json()
  const newUser = await prisma.user.create({
    data: {
      name,
      email,
      password: await bcrypt.hash(password, 10),
    },
  })

  return NextResponse.json([
    {
      lol: true,
      id: newUser.id,
    },
  ])
}
