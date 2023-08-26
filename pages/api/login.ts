import { validLogin } from '../../lib/user'

export default async function login(req: any, res: any) {
  if (req.method === 'POST') {
    const { email, password } = req.body

    const isValid = await validLogin({ email, password })
    res.status(200).json({ status: isValid ? 'success' : 'failure' })
  }
}
