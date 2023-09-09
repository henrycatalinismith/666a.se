'use client'
import { clsx } from 'clsx'
import Link from 'next/link'

export default function NavBar() {
  const links = [
    {
      href: '/dashboard',
      text: 'Home',
    },
    {
      href: '/subscriptions',
      text: 'Subscriptions',
    },
  ]
  return (
    <header className="sticky inset-x-0 top-0 z-50 border-b border-gray-200 bg-white">
      <div className="container flex flex-1 items-center gap-4">
        <div className={clsx('flex h-14', 'items-center')}>666a</div>

        <nav aria-label="Global" className="hidden sm:block lg:flex-1">
          <ul className="gap-4 flex">
            {links.map((l) => (
              <li key={l.href} className="">
                <Link href={l.href}>
                  <div className="block text-s font-medium text-gray-900 hover:opacity-75">
                    {l.text}
                  </div>
                </Link>
              </li>
            ))}
          </ul>
        </nav>
      </div>
    </header>
  )
}
