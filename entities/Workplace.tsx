import { faBuilding } from '@fortawesome/free-solid-svg-icons/faBuilding'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const WorkplaceIconDefinition = faBuilding

export const WorkplaceIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (
  props
) => {
  return <FontAwesomeIcon {...props} icon={WorkplaceIconDefinition} />
}
