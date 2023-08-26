import bcrypt from 'bcrypt'
import { NextResponse } from 'next/server'

import { createSession } from '../../lib/session'
import { findUserByEmail } from '../../lib/user'

export async function POST(request: Request) {
  const { email, password } = await request.json()

  const fail = () => NextResponse.json({ status: 'failure' })
  const user = await findUserByEmail({ email })
  if (!user) {
    return fail()
  }

  const valid = await bcrypt.compare(password, user.password)
  if (!valid) {
    return fail()
  }

  const session = await createSession({ user_id: user.id as any as number })
  const response = NextResponse.json({ status: 'success' })
  response.cookies.set('session', session.secret)
  return response
}
