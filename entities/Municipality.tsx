import { faCity } from '@fortawesome/free-solid-svg-icons'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const MunicipalityIconDefinition = faCity

export const MunicipalityIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (
  props
) => {
  return <FontAwesomeIcon {...props} icon={MunicipalityIconDefinition} />
}
