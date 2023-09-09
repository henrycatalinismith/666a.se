import { faEarthEurope } from '@fortawesome/free-solid-svg-icons/faEarthEurope'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const CountyIconDefinition = faEarthEurope

export const CountyIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={CountyIconDefinition} />
}
