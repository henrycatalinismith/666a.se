import { SessionStatus } from '@prisma/client'
import bcrypt from 'bcrypt'
import { NextResponse } from 'next/server'
import { v4 as uuid } from 'uuid'

import prisma from 'lib/database'

export async function POST(request: Request) {
  const { name, companyCode, email, password } = await request.json()

  let user

  try {
    user = await prisma.user.create({
      data: {
        name,
        email,
        password: await bcrypt.hash(password, 10),
      },
    })
  } catch (e) {
    return NextResponse.json({
      status: 'error',
    })
  }

  await prisma.subscription.create({
    data: {
      userId: user.id,
      companyCode,
    },
  })

  const session = await prisma.session.create({
    data: {
      userId: user.id,
      secret: uuid(),
      status: SessionStatus.ACTIVE,
    },
  })

  const response = NextResponse.json({
    status: 'success',
    id: user.id,
    destination: '/dashboard',
  })

  response.cookies.set('session', session.secret)

  return response
}
