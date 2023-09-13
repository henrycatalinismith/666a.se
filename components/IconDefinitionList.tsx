'use client'

import { IconDefinition } from '@fortawesome/fontawesome-svg-core'
import { faFloppyDisk } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import {
  FC,
  createContext,
  useCallback,
  useContext,
  useEffect,
  useRef,
  useState,
} from 'react'

const EditableContext = createContext(false)
const EditingContext = createContext(false)
const SetEditingContext = createContext<(e: boolean) => void>(() => {})

export const IconDefinitionList: FC<{ children: any }> = ({ children }) => {
  return (
    <>
      <div className="flex flex-col gap-4">{children}</div>
    </>
  )
}

export const IconDefinitionListRow: FC<{
  children: any
  editable?: boolean
}> = ({ children, editable }) => {
  const [editing, setEditing] = useState(false)
  return (
    <>
      <div className="flex flex-row gap-2">
        <EditableContext.Provider value={editable ?? false}>
          <EditingContext.Provider value={editing}>
            <SetEditingContext.Provider value={(e: boolean) => setEditing(e)}>
              {children}
            </SetEditingContext.Provider>
          </EditingContext.Provider>
        </EditableContext.Provider>
      </div>
    </>
  )
}

export const IconDefinitionListIcon: FC<{ icon: IconDefinition }> = ({
  icon,
}) => {
  const editable = useContext(EditableContext)
  const editing = useContext(EditingContext)
  const setEditing = useContext(SetEditingContext)
  const onClick = () => setEditing(!editing)
  const displayIcon = editing ? faFloppyDisk : icon
  return (
    <>
      <div className="flex min-w-[4rem] w-16 justify-center items-center">
        {editable ? (
          <button onClick={onClick}>
            <FontAwesomeIcon icon={displayIcon} className="h-8" />
          </button>
        ) : (
          <FontAwesomeIcon icon={displayIcon} className="h-8" />
        )}
      </div>
    </>
  )
}

export const IconDefinitionListItem: FC<{ children: any }> = ({ children }) => {
  return (
    <>
      <div className="flex flex-col min-w-0 flex-1">{children}</div>
    </>
  )
}

export const IconDefinitionListTerm: FC<{ children: any }> = ({ children }) => {
  return (
    <>
      <span className="text-muted-foreground whitespace-nowrap overflow-hidden text-ellipsis max-w-full min-w-0">
        {children}
      </span>
    </>
  )
}

export const IconDefinitionListDefinition: FC<{ children: any }> = ({
  children,
}) => {
  const editing = useContext(EditingContext)
  const input = useRef<HTMLInputElement>(null)
  const [value, setValue] = useState(children)

  useEffect(() => {
    if (editing && input.current) {
      input.current.focus()
    }
  }, [editing])

  const onChange = useCallback((event: React.FormEvent<HTMLInputElement>) => {
    setValue(event.currentTarget.value)
  }, [])

  return (
    <>
      {editing ? (
        <input type="text" value={value} ref={input} onChange={onChange} />
      ) : (
        <span className="font-bold whitespace-nowrap overflow-hidden text-ellipsis">
          {children}
        </span>
      )}
    </>
  )
}
