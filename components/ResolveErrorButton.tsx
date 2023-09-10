'use client'

import { Error } from '@prisma/client'
import { FC } from 'react'
import { Button } from 'ui/Button'

export type ResolveErrorButtonProps = {
  error: Error
}

export const ResolveErrorButton: FC<ResolveErrorButtonProps> = ({ error }) => {
  const onResolve = () => {
    fetch(`/errors/${error.id}/resolve`, { method: 'POST' })
  }
  return (
    <Button className="w-min" onClick={onResolve}>
      Resolve
    </Button>
  )
}
