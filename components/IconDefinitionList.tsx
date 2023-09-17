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

type RowState = {
  ui: RowUiState
  value: string
}
type RowUiState = 'uneditable' | 'editable' | 'editing'
type RowActionType = 'edit' | 'change' | 'save'
type RowAction = { type: RowActionType } | { type: 'change'; payload: string }
type RowDispatch = (action: RowAction) => void

const RowContext = createContext<[RowState, RowDispatch]>([
  { ui: 'uneditable', value: '' },
  () => {},
])

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
  onSave?: (v: any) => void
}> = ({ children, editable, onSave }) => {
  const [rowState, setRowState] = useState<RowState>({
    ui: editable ? 'editable' : 'uneditable',
    value: '',
  })

  const dispatch = useCallback(
    (action: RowAction) => {
      if (rowState.ui === 'uneditable') {
        return
      }
      if (action.type === 'edit') {
        setRowState({ ...rowState, ui: 'editing' })
        return
      }
      if (action.type === 'change') {
        setRowState({ ...rowState, value: (action as any).payload })
        return
      }
      if (action.type === 'save') {
        onSave(rowState.value)
        setRowState({ ...rowState, ui: 'editable' })
        return
      }
    },
    [onSave, rowState]
  )
  return (
    <>
      <div className="flex flex-row gap-2">
        <RowContext.Provider value={[rowState, dispatch]}>
          {children}
        </RowContext.Provider>
      </div>
    </>
  )
}

export const IconDefinitionListIcon: FC<{ icon: IconDefinition }> = ({
  icon,
}) => {
  const [state, dispatch] = useContext(RowContext)
  const displayIcon = state.ui === 'editing' ? faFloppyDisk : icon
  const onClick = useCallback(() => {
    if (state.ui === 'editable') {
      dispatch({ type: 'edit' })
    } else if (state.ui === 'editing') {
      dispatch({ type: 'save' })
    }
  }, [dispatch, state])
  return (
    <>
      <div className="flex min-w-[4rem] w-16 justify-center items-center">
        {['editable', 'editing'].includes(state.ui) ? (
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
  const [state, dispatch] = useContext(RowContext)
  const input = useRef<HTMLInputElement>(null)
  const [value, setValue] = useState(children)

  useEffect(() => {
    if (state.ui === 'editing' && input.current) {
      input.current.focus()
    }
  }, [state])

  const onChange = useCallback(
    (event: React.FormEvent<HTMLInputElement>) => {
      dispatch({ type: 'change', payload: event.currentTarget.value })
      setValue(event.currentTarget.value)
    },
    [dispatch]
  )

  return (
    <>
      {state.ui === 'editing' ? (
        <input type="text" value={value} ref={input} onChange={onChange} />
      ) : (
        <span className="font-bold whitespace-nowrap overflow-hidden text-ellipsis">
          {state.value ? state.value : children}
        </span>
      )}
    </>
  )
}
