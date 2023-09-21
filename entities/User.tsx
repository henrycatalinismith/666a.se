import { faUser } from '@fortawesome/free-solid-svg-icons/faUser'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const UserIconDefinition = faUser

export const UserIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={UserIconDefinition} />
}
