'use client'
import { faBars } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import Link from 'next/link'
import { FC } from 'react'

import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from './DropdownMenu'

export type NavBarProps = {
  links: {
    href: string
    text: string
  }[]
}

export const NavBar: FC<NavBarProps> = ({ links }) => {
  return (
    <header className="sticky inset-x-0 top-0 z-50 border-b border-gray-200 bg-white">
      <div className="container flex flex-1 items-center justify-between">
        <a className="font-bold flex h-14 items-center" href="/">
          666a
        </a>
        <DropdownMenu>
          <DropdownMenuTrigger className="flex flex-row gap-2 items-center">
            <FontAwesomeIcon icon={faBars} />
            <span className="text-sm">Menu</span>
          </DropdownMenuTrigger>
          <DropdownMenuContent>
            {links.map((link) => (
              <DropdownMenuItem key={link.href}>
                <Link href={link.href}>{link.text}</Link>
              </DropdownMenuItem>
            ))}
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  )
}
