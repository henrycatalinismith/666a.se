import { faBell } from '@fortawesome/free-solid-svg-icons/faBell'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const NotificationIconDefinition = faBell

export const NotificationIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (
  props
) => {
  return <FontAwesomeIcon {...props} icon={NotificationIconDefinition} />
}
