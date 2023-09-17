// import { Login } from 'forms/Login'

import { Login } from 'forms/Login'
import { useTranslations } from 'next-intl'

export const preferredRegion = 'home'
export const dynamic = 'force-dynamic'
export const runtime = 'nodejs'

export default function Home() {
  return (
    <div className="h-screen bg-snow w-full flex justify-center items-center">
      <Login />
    </div>
  )
}
