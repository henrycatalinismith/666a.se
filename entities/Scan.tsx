import { faSatelliteDish } from '@fortawesome/free-solid-svg-icons/faSatelliteDish'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const ScanIconDefinition = faSatelliteDish

export const ScanIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={ScanIconDefinition} />
}
