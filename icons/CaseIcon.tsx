import { faBoxArchive } from '@fortawesome/free-solid-svg-icons/faBoxArchive'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const CaseIconDefinition = faBoxArchive

export const CaseIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={CaseIconDefinition} />
}
