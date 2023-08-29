import { cookies } from 'next/headers'
import { redirect } from 'next/navigation'

import prisma from './database'

export async function requireUser() {
  const cookieStore = cookies()
  const secret = cookieStore.get('session')?.value || ''
  const session = await prisma.session.findFirst({
    where: { secret },
    include: { user: true },
  })

  if (!session) {
    redirect('/')
    return
  }

  return session.user
}
