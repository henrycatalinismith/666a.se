'use client'
import { FC } from 'react'
import { Button } from 'ui/Button'

export type CheckButtonProps = {
  id: string
}

export const CheckButton: FC<CheckButtonProps> = ({ id }) => {
  const onCheck = async () => {
    const params = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
    }
    const response = await fetch(`/api/subscriptions/${id}/check`, params).then(
      (response) => response.json()
    )
    console.log(response)
  }
  return (
    <>
      <Button onClick={onCheck}>Check</Button>
    </>
  )
}
