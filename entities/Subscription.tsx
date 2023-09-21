import { faStar } from '@fortawesome/free-solid-svg-icons/faStar'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const SubscriptionIconDefinition = faStar

export const SubscriptionIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (
  props
) => {
  return <FontAwesomeIcon {...props} icon={SubscriptionIconDefinition} />
}
