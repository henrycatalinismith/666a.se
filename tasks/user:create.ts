import { createUser } from '../lib/user'
;(async () => {
  const name = process.argv[2]
  const email = process.argv[3]
  const password = process.argv[4]
  await createUser({ name, email, password })
})()
