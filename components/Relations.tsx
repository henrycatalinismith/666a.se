import { IconDefinition } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import Link from 'next/link'
import { FC } from 'react'

export type RelationsProps = {
  rows: {
    icon: IconDefinition
    href: string
    text: any
    show: boolean
  }[]
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
                <FontAwesomeIcon icon={row.icon} className="h-6" />
              </div>
              <Link
                href={row.href}
                className="text-blue-700 self-center whitespace-nowrap overflow-hidden text-ellipsis max-w-full min-w-0"
              >
                {row.text}
              </Link>
            </li>
          ))}
      </ol>
    </>
  )
}
