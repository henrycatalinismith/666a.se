'use client'

import { Error } from '@prisma/client'
import { ErrorIcon } from 'entities/Error'
import { FC } from 'react'
import { Button } from 'ui/Button'
import { Card } from 'ui/Card'

export type DashboardErrorProps = {
  error: Error
}

export const DashboardError: FC<DashboardErrorProps> = ({ error }) => {
  const onResolve = () => {
    fetch(`/errors/${error.id}/resolve`, { method: 'POST' })
  }
  return (
    <Card className="p-8 mt-8 mb-8 ">
      <div className="flex scroll-m-20 font-bold tracking-tight flex-row items-center gap-2">
        <div className="border-black border-4 rounded-full w-16 h-16 min-w-[4rem] flex items-center justify-center">
          <a href={`/errors/${error.id}`}>
            <ErrorIcon className="h-8" />
          </a>
        </div>
        <div className="flex flex-col min-w-0 flex-1">
          <p className="text-1xl whitespace-nowrap overflow-hidden text-ellipsis">
            <a href={`/errors/${error.id}`}>
              {`${error.message.split('\n')[0]}`}
            </a>
          </p>
          <p className="text-1xl text-muted-foreground whitespace-nowrap overflow-hidden text-ellipsis">
            <a href={`/errors/${error.id}`}>{error.id}</a>
          </p>
        </div>
        <Button onClick={onResolve}>Resolve</Button>
      </div>
    </Card>
  )
}

// <pre>
//   <code>{error.message}</code>
// </pre>
