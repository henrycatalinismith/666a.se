'use client'
import { Error } from '@prisma/client'

import { Button } from '../ui/Button'
import { Card } from '../ui/Card'

export function Error({ error }: { error: Error }) {
  const onResolve = () => {
    fetch(`/errors/${error.id}/resolve`, { method: 'POST' })
  }
  return (
    <Card className="mt-4 p-4">
      <Button onClick={onResolve}>Resolve</Button>
      <pre>
        <code>{error.message}</code>
      </pre>
    </Card>
  )
}
