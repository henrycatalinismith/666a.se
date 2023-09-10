import { faBug } from '@fortawesome/free-solid-svg-icons/faBug'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const ErrorIconDefinition = faBug

export const ErrorIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={ErrorIconDefinition} />
}
