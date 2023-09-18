import { User } from '@prisma/client'
// import { useTranslations } from 'next-intl'
import { FC } from 'react'

export const SettingsName: FC<{ user: User }> = ({ user }) => {
  // const t = useTranslations('Settings')

  user.name

  return (
    <div className="container py-8 flex flex-col gap-4">
      <h1 className="text-2xl font-bold">Change Name</h1>
      <p className="max-w-xl">The name</p>
    </div>
  )
}
