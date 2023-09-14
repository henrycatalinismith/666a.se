import { faStamp } from '@fortawesome/free-solid-svg-icons/faStamp'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const TypeIconDefinition = faStamp

export const TypeIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={TypeIconDefinition} />
}
