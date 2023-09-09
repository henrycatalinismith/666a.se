import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export type IconHeadingProps = {
  icon: any
  title: string
  subtitle: string
}

export const IconHeading: FC<IconHeadingProps> = ({
  icon,
  title,
  subtitle,
}) => {
  return (
    <>
      <div className="flex scroll-m-20 font-bold tracking-tight flex-row items-center gap-2">
        <div className="border-black border-4 rounded-full w-16 h-16 flex items-center justify-center">
          <FontAwesomeIcon icon={icon} className="h-8" />
        </div>
        <div className="flex flex-col">
          <h1 className="text-4xl">{title}</h1>
          <p className="text-lg text-muted-foreground">{subtitle}</p>
        </div>
      </div>
    </>
  )
}
