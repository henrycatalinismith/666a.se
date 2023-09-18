import Image from 'next/image'
import { useTranslations } from 'next-intl'

export const preferredRegion = 'home'
export const dynamic = 'force-dynamic'
export const runtime = 'nodejs'

export default function Home() {
  const t = useTranslations('Hero')
  return (
    <section className="container relative mx-auto py-4 ">
      <div className="absolute top-0 left-0 w-full h-full bg-white opacity-40"></div>
      <div className="relative z-10 gap-5 items-center lg:flex">
        <div className="flex-1 max-w-lg py-5 sm:mx-auto sm:text-center lg:max-w-max lg:text-left">
          <h1 className="text-3xl text-gray-800 font-semibold md:text-4xl">
            {t('automated')}{' '}
            <span className="text-indigo-600">
              {t('workEnvironmentAuthority')}
            </span>{' '}
            {t('emailAlerts')}
          </h1>
          <p className="text-gray-500 leading-relaxed mt-3">
            {t('stopWorrying')}
          </p>
          <a
            className="mt-5 px-4 py-2 text-indigo-600 font-medium bg-indigo-50 rounded-full inline-flex items-center"
            href="javascript:void()"
          >
            {t('cta')}
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-6 w-6 ml-1 duration-150"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M13 7l5 5m0 0l-5 5m5-5H6"
              />
            </svg>
          </a>
        </div>
        <div className="flex-1 mt-5 mx-auto sm:w-9/12 lg:mt-0 lg:w-auto">
          <Image
            src="/hero.png"
            alt="Hey henry,
You're subscribed to email updates for Arbetsmiljöverket filings about company 556744-3337. A new public filing was made today for that company.
Case name: Inspektion inom Ovrig tillsyn.
Document type: Tjänsteanteckning.
Document code: 2023/040689-3.
More information's available about it on Arbetsmiliöverket's website at the link below."
            className="w-full"
            width={704}
            height={535}
          />
        </div>
      </div>
    </section>
  )
}
