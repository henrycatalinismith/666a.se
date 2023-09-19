import { notFound } from 'next/navigation'
import { NextIntlClientProvider } from 'next-intl'

import { sessionUser } from 'lib/authentication'
import { NavBar } from 'ui/NavBar'

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
          <div className="flex flex-col">{children}</div>
        </NextIntlClientProvider>
      </body>
    </html>
  )
}
