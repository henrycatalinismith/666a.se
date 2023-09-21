'use client'
import { FC } from 'react'

import { Button } from 'ui/Button'

export type RefreshButtonProps = {
  id: string
}

export const RefreshButton: FC<RefreshButtonProps> = ({ id }) => {
  const onCheck = async () => {
    const params = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
    }
    const response = await fetch(`/api/subscriptions/${id}/refresh`, params).then(
      (response) => response.json()
    )
    console.log(response)
  }
  return (
    <>
      <Button onClick={onCheck}>Refresh</Button>
    </>
  )
}
