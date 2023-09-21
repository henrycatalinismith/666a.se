import Link from 'next/link'
import { notFound } from 'next/navigation'
import { NextIntlClientProvider } from 'next-intl'
import { NavBar } from 'ui/NavBar'
import { sessionUser } from 'lib/authentication'

export function generateStaticParams() {
  return [{ locale: 'en' }, { locale: 'de' }]
}

type LayoutProps = {
  children: any
  params: any
}

export default async function LocaleLayout({
  children,
  params: { locale },
}: LayoutProps) {
  const user = await sessionUser()

  let messages: any
  try {
    messages = (await import(`../../messages/${locale}.json`)).default
  } catch (error) {
    notFound()
  }

  const links = user
  ? [
      {
        href: `/${locale}/dashboard`,
        text: messages.NavBar.dashboard,
      },
      {
        href: `/${locale}/logout`,
        text: messages.NavBar.logout,
      },
    ]
  : [
      {
        href: `/${locale}/login`,
        text: messages.NavBar.login,
      },
      {
        href: `/${locale}/register`,
        text: messages.NavBar.register,
      },
    ]

  return (
    <html lang={locale}>
      <body>
        <NextIntlClientProvider locale={locale} messages={messages}>
          <NavBar links={links} />
          <div className="flex flex-col min-h-screen">{children}</div>

          <footer className="bg-white rounded-lg shadow m-4 dark:bg-gray-800">
            <div className="w-full mx-auto max-w-screen-xl p-4 md:flex md:items-center md:justify-between">
              <ul className="flex flex-wrap items-center mt-3 text-sm font-medium text-gray-500 dark:text-gray-400 sm:mt-0">
                <li>
                  <Link
                    href="/policies/privacy-policy"
                    className="mr-4 hover:underline md:mr-6"
                  >
                    Privacy
                  </Link>
                </li>

                <li>
                  <Link
                    href="/policies/accessibility-statement"
                    className="mr-4 hover:underline md:mr-6"
                  >
                    Accessibility
                  </Link>
                </li>

                <li>
                  <Link
                    href="/policies/terms-of-service"
                    className="mr-4 hover:underline md:mr-6"
                  >
                    Terms of Service
                  </Link>
                </li>
              </ul>
            </div>
          </footer>
        </NextIntlClientProvider>
      </body>
    </html>
  )
}
