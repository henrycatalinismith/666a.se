import { IconDefinition } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import Link from 'next/link'
import { FC } from 'react'

export type EntityListProps = {
  items: {
    icon: IconDefinition
    text: string
    href: string
    subtitle: string
  }[]
}

export const EntityList: FC<EntityListProps> = ({ items }) => {
  return (
    <ol className="flex flex-col gap-4">
      {items.map((item, i) => (
        <li key={`item-${i}`} className="flex flex-row gap-2">
          <div className="flex min-w-[4rem] w-16 justify-center items-center">
            <FontAwesomeIcon icon={item.icon} className="h-8" />
          </div>
          <div className="flex flex-col min-w-0">
            <Link
              href={item.href}
              className="text-blue-700 whitespace-nowrap overflow-hidden text-ellipsis max-w-full min-w-0"
            >
              {item.text}
            </Link>
            <span className="text-muted-foreground whitespace-nowrap overflow-hidden text-ellipsis">
              {item.subtitle}
            </span>
          </div>
        </li>
      ))}
    </ol>
  )
}
