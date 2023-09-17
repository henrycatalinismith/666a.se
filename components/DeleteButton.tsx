'use client'
import { FC } from 'react'

import { Button } from 'ui/Button'

export type DeleteButtonProps = {
  url: string
}

export const DeleteButton: FC<DeleteButtonProps> = ({ url }) => {
  const onDelete = async () => {
    const params = {
      method: 'DELETE',
      headers: { 'Content-Type': 'application/json' },
    }
    const response = await fetch(url, params).then((response) =>
      response.json()
    )
    console.log(response)
  }
  return (
    <>
      <Button key="delete" onClick={onDelete}>
        Delete
      </Button>
    </>
  )
}
