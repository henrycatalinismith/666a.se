import { notFound } from 'next/navigation'
import { NextIntlClientProvider } from 'next-intl'

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
  let messages
  try {
    messages = (await import(`../../messages/${locale}.json`)).default
  } catch (error) {
    notFound()
  }

  return (
    <html lang={locale}>
      <body>
        <NextIntlClientProvider locale={locale} messages={messages}>
          {children}
        </NextIntlClientProvider>
      </body>
    </html>
  )
}
