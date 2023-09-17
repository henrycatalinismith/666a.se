'use client'
import { FC } from 'react'
import { Button } from 'ui/Button'

export type SendButtonProps = {
  id: string
}

export const SendButton: FC<SendButtonProps> = ({ id }) => {
  const onSend = async () => {
    const params = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
    }
    const response = await fetch(`/api/notifications/${id}/send`, params).then(
      (response) => response.json()
    )
    console.log(response)
  }
  return (
    <>
      <Button onClick={onSend}>Send</Button>
    </>
  )
}
