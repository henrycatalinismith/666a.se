import { RoleName, RoleStatus } from '@prisma/client'
import bcrypt from 'bcrypt'
import prisma from 'lib/database'
import _ from 'lodash'
import { NextResponse } from 'next/server'
import { v4 as uuid } from 'uuid'

export async function POST(request: Request) {
  const { email, password } = await request.json()

  const fail = () => NextResponse.json({ status: 'failure' })
  const user = await prisma.user.findFirst({
    where: { email },
    include: { roles: { where: { status: RoleStatus.ACTIVE } } },
  })
  if (!user) {
    return fail()
  }

  const valid = await bcrypt.compare(password, user.password)
  if (!valid) {
    return fail()
  }

  const session = await prisma.session.create({
    data: {
      userId: user.id,
      secret: uuid(),
    },
  })
  const activeRoles = _.map(user.roles, 'name')
  const destination = activeRoles.includes(RoleName.DEVELOPER)
    ? '/admin'
    : '/dashboard'
  const response = NextResponse.json({ status: 'success', destination })
  response.cookies.set('session', session.secret)
  return response
}
