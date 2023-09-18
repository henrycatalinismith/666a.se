'use client'
import { useRouter } from 'next/navigation'
import { useTranslations } from 'next-intl'
import { FC } from 'react'

import { Button } from 'ui/Button'

export const LogoutButton: FC = () => {
  const t = useTranslations('Logout')
  const router = useRouter()
  const onClick = async () => {
    const params = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
    }
    await fetch('/api/me/logout', params)
    router.push('/en/login')
  }
  return (
    <>
      <Button className="w-max" onClick={onClick}>
        {t('button')}
      </Button>
    </>
  )
}
