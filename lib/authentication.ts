import { RoleName, RoleStatus } from '@prisma/client'
import _ from 'lodash'
import { cookies } from 'next/headers'
import { redirect } from 'next/navigation'

import prisma from './database'

export async function sessionUser() {
  const cookieStore = cookies()
  const secret = cookieStore.get('session')?.value || ''
  const session = await prisma.session.findFirst({
    where: { secret },
    include: {
      user: { include: { roles: { where: { status: RoleStatus.ACTIVE } } } },
    },
  })
  if (!session) {
    return null
  }

  return session.user
}

export async function requireUser(requiredRoles?: RoleName[]) {
  const cookieStore = cookies()
  const secret = cookieStore.get('session')?.value || ''
  const session = await prisma.session.findFirst({
    where: { secret },
    include: {
      user: { include: { roles: { where: { status: RoleStatus.ACTIVE } } } },
    },
  })

  if (!session) {
    redirect('/')
  }

  if (!requiredRoles) {
    return session.user
  }

  const activeRoles = _.map(session.user.roles, 'name')
  const missingRoles = _.difference(requiredRoles, activeRoles)
  if (missingRoles.length === requiredRoles.length) {
    redirect('/')
  }

  return session.user
}
