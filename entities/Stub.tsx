import { faCube } from '@fortawesome/free-solid-svg-icons/faCube'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const StubIconDefinition = faCube

export const StubIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={StubIconDefinition} />
}
