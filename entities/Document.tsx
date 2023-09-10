import { faFileLines } from '@fortawesome/free-solid-svg-icons/faFileLines'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const DocumentIconDefinition = faFileLines

export const DocumentIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={DocumentIconDefinition} />
}
