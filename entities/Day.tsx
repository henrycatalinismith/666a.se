import { faCalendarDay } from '@fortawesome/free-solid-svg-icons/faCalendarDay'
import {
  FontAwesomeIcon,
  FontAwesomeIconProps,
} from '@fortawesome/react-fontawesome'
import { FC } from 'react'

export const DayIconDefinition = faCalendarDay

export const DayIcon: FC<Omit<FontAwesomeIconProps, 'icon'>> = (props) => {
  return <FontAwesomeIcon {...props} icon={DayIconDefinition} />
}
