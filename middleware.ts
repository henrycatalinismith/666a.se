import createMiddleware from 'next-intl/middleware'

export default createMiddleware({
  locales: ['en', 'sv'],
  defaultLocale: 'sv',
  localePrefix: 'always',
})

export const config = {
  matcher: ['/((?!api|admin|_next|.*\\..*).*)'],
}
