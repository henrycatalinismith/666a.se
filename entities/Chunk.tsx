import { faCubes } from '@fortawesome/free-solid-svg-icons/faCubes'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const ChunkIconDefinition = faCubes

export const ChunkIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={ChunkIconDefinition} />
}
