import withNextIntl from 'next-intl/plugin'

const withIntl = withNextIntl(
  // This is the default (also the `src` folder is supported out of the box)
  './i18n.ts'
)

/** @type {import('next').NextConfig} */
const nextConfig = withIntl({})

export default nextConfig
