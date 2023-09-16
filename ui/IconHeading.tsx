import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import Link from 'next/link'
import { FC } from 'react'

import { buttonVariants } from './Button'

export type IconHeadingProps = {
  icon: any
  title: string
  subtitle: string
  newUrl?: string
  actions?: any[]
}

export const IconHeading: FC<IconHeadingProps> = ({
  icon,
  title,
  subtitle,
  newUrl,
  actions,
}) => {
  return (
    <>
      <div className="flex scroll-m-20 font-bold tracking-tight flex-row items-center gap-2">
        <div className="border-black border-4 rounded-full w-16 h-16 min-w-[4rem] flex items-center justify-center">
          <FontAwesomeIcon icon={icon} className="h-8" />
        </div>
        <h1 className="flex flex-col min-w-0 flex-1">
          <span className="text-1xl text-muted-foreground whitespace-nowrap overflow-hidden text-ellipsis m:overflow-visible">
            {title}
          </span>
          <span className="text-1xl whitespace-nowrap overflow-hidden text-ellipsis m:overflow-visible">
            {subtitle}
          </span>
        </h1>
        <div>
          {newUrl && (
            <Link
              href={newUrl}
              className={buttonVariants({ variant: 'default' })}
            >
              New
            </Link>
          )}
          {actions && actions?.length > 0 && actions}
        </div>
      </div>
    </>
  )
}
