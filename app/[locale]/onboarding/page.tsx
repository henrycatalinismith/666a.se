import { useTranslations } from 'next-intl'

import { Onboarding } from 'forms/Onboarding'

export default function OnboardingPage() {
  const t = useTranslations('Onboarding')
  return (
    <div className="container py-8 flex flex-col gap-4">
      <h1 className="text-2xl font-bold">{t('title')}</h1>
      <p className="max-w-xl">{t('orgNumber')}</p>
      <Onboarding />
    </div>
  )
}
