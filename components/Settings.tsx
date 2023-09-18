import { User } from '@prisma/client'
import Link from 'next/link'
import { useTranslations } from 'next-intl'
import { FC } from 'react'

export const Settings: FC<{ user: User }> = ({ user }) => {
  const t = useTranslations('Settings')

  return (
    <div className="container py-8 flex flex-col gap-4">
      <h1 className="text-2xl font-bold">{t('title')}</h1>

      <div>
        <h2 className="text-xl font-bold">Name</h2>
        <p className="max-w-xl">
          {user.name}{' '}
          <Link className="text-blue-700" href="/settings/name">
            (change name)
          </Link>
        </p>
      </div>

      <div>
        <h2 className="text-xl font-bold">Email</h2>
        <p className="max-w-xl">
          {user.email}{' '}
          <Link className="text-blue-700" href="/settings/email">
            (change email)
          </Link>
        </p>
      </div>

      <div>
        <h2 className="text-xl font-bold">Password</h2>
        <p className="max-w-xl">
          *************{' '}
          <Link className="text-blue-700" href="/settings/email">
            (change password)
          </Link>
        </p>
      </div>
    </div>
  )
}
