import { faMagnifyingGlass } from '@fortawesome/free-solid-svg-icons/faMagnifyingGlass'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const SearchIconDefinition = faMagnifyingGlass

export const SearchIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (
  props
) => {
  return <FontAwesomeIcon {...props} icon={SearchIconDefinition} />
}
