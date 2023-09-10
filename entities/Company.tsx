import { faPeopleGroup } from '@fortawesome/free-solid-svg-icons/faPeopleGroup'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const CompanyIconDefinition = faPeopleGroup

export const CompanyIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={CompanyIconDefinition} />
}
