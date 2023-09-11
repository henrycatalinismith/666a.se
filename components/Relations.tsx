import { IconDefinition } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import Link from 'next/link'
import { FC } from 'react'

type BaseRow = {
  type?: 'link' | 'text'
  icon: IconDefinition
  text: any
  subtitle: string
  show: boolean
}

type LinkRow = BaseRow & {
  href: string
}

type TextRow = BaseRow & {
  type: 'text'
}

type Row = LinkRow | TextRow

export type RelationsProps = {
  rows: Row[]
}

export const Relations: FC<RelationsProps> = ({ rows }) => {
  return (
    <>
      <ol className="flex flex-col gap-4">
        {rows
          .filter((r) => r.show)
          .map((row, i) => (
            <li key={`relation-${i}`} className="flex flex-row gap-2">
              <div className="flex min-w-[4rem] w-16 justify-center items-center">
                <FontAwesomeIcon icon={row.icon} className="h-8" />
              </div>
              {row.type === 'text' ? (
                <div className="flex flex-col min-w-0">
                  <span className="text-muted-foreground whitespace-nowrap overflow-hidden text-ellipsis max-w-full min-w-0">
                    {row.text}
                  </span>
                  <span className="font-bold whitespace-nowrap overflow-hidden text-ellipsis">
                    {row.subtitle}
                  </span>
                </div>
              ) : (
                <Link href={row.href} className="flex flex-col min-w-0">
                  <span className="text-muted-foreground whitespace-nowrap overflow-hidden text-ellipsis max-w-full min-w-0">
                    {row.text}
                  </span>
                  <span className="font-bold text-blue-700 whitespace-nowrap overflow-hidden text-ellipsis">
                    {row.subtitle}
                  </span>
                </Link>
              )}
            </li>
          ))}
      </ol>
    </>
  )
}
