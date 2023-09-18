import { Subscription } from '@prisma/client'
import { useTranslations } from 'next-intl'
import { FC } from 'react'

export const Dashboard: FC<{ subscription: Subscription }> = ({
  subscription,
}) => {
  const t = useTranslations('Dashboard')

  return (
    <div className="container py-8 flex flex-col gap-4">
      <h1 className="text-2xl font-bold">{t('title')}</h1>
      <p className="max-w-xl">
        {t('subscription', { companyCode: subscription.companyCode })}
      </p>
    </div>
  )
}
