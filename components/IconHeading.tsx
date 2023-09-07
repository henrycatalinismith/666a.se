import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export type IconHeadingProps = {
  icon: any
  children: string
}

export const IconHeading: FC<IconHeadingProps> = ({ icon, children }) => {
  return (
    <>
      <h1 className="flex scroll-m-20 font-bold tracking-tight flex-row items-center gap-2">
        <FontAwesomeIcon icon={icon} className="h-6" />
        <span className="text-4xl">{children}</span>
      </h1>
    </>
  )
}
