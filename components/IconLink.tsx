import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import Link from 'next/link'
import { FC } from 'react'

export type IconLinkProps = {
  icon: any
  href: string
  children: string
}

export const IconLink: FC<IconLinkProps> = ({ icon, href, children }) => {
  return (
    <>
      <Link href={href} className="flex flex-row gap-2 items-center">
        <FontAwesomeIcon icon={icon} className="h-4 w-4" />
        <span className="text-blue-700 underline whitespace-nowrap">
          {children}
        </span>
      </Link>
    </>
  )
}
