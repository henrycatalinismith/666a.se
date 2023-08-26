import bcrypt from 'bcrypt'
import { serialize } from 'cookie'
import { NextApiRequest, NextApiResponse } from 'next'

import { createSession } from '../../lib/session'
import { findUserByEmail } from '../../lib/user'

export default async function login(req: NextApiRequest, res: NextApiResponse) {
  if (req.method === 'POST') {
    const { email, password } = req.body

    const fail = () => res.status(200).json({ status: 'failure' })
    const user = await findUserByEmail({ email })
    if (!user) {
      return fail()
    }

    const valid = await bcrypt.compare(password, user.password)
    if (!valid) {
      return fail()
    }

    const session = await createSession({ user_id: user.id as any as number })
    res.setHeader(
      'Set-Cookie',
      serialize('session', session.secret, { path: '/' })
    )

    res.status(200).json({ status: 'success' })
  }
}
