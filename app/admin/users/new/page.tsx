import { RoleName } from '@prisma/client'

import { NewUser } from 'forms/NewUser'
import { requireUser } from 'lib/authentication'

export default async function NewUserPage() {
  const user = await requireUser([RoleName.Developer])
  if (!user) {
    return <></>
  }

  return (
    <>
      <div className="container pt-8 flex flex-col gap-2">
        <h1>New User</h1>
        <div className="bg-snow flex justify-start items-center">
          <NewUser />
        </div>
      </div>
    </>
  )
}
