import { useTranslations } from 'next-intl'

import { LogoutButton } from 'components/LogoutButton'

export default function Logout() {
  const t = useTranslations('Logout')
  return (
    <div className="container py-8 flex flex-col gap-4">
      <h1 className="text-2xl font-bold">{t('title')}</h1>
      <p>{t('steps')}</p>
      <p>{t('impact')}</p>
      <LogoutButton />
    </div>
  )
}
