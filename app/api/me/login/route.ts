import { RoleName, RoleStatus, SessionStatus } from '@prisma/client'
import bcryptjs from 'bcryptjs'
import _ from 'lodash'
import { NextResponse } from 'next/server'
import { v4 as uuid } from 'uuid'

import prisma from 'lib/database'

export async function POST(request: Request) {
  const { email, password } = await request.json()

  const fail = () => NextResponse.json({ status: 'failure' })
  const user = await prisma.user.findFirst({
    where: { email },
    include: { roles: { where: { status: RoleStatus.Active } } },
  })
  if (!user) {
    return fail()
  }

  const valid = await bcryptjs.compareSync(password, user.password)
  if (!valid) {
    return fail()
  }

  const session = await prisma.session.create({
    data: {
      userId: user.id,
      secret: uuid(),
      status: SessionStatus.Active,
    },
  })

  const activeRoles = _.map(user.roles, 'name')
  const destination = activeRoles.includes(RoleName.Developer)
    ? '/admin'
    : '/dashboard'
  const response = NextResponse.json({ status: 'success', destination })
  response.cookies.set('session', session.secret)
  return response
}
