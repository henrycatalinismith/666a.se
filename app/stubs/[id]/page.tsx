import { faCube } from '@fortawesome/free-solid-svg-icons'

import { IconHeading } from '../../../components/IconHeading'
import { requireUser } from '../../../lib/authentication'
import prisma from '../../../lib/database'

export default async function Document({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const stub = await prisma.stub.findFirstOrThrow({
    where: { id: params.id },
    include: { document: true },
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-8">
        <div className="space-y-3">
          <IconHeading icon={faCube}>{stub.id}</IconHeading>
          <p className="text-lg text-muted-foreground">
            {stub.created.toISOString().substring(0, 19).replace('T', ' ')}
          </p>
        </div>
      </div>
    </>
  )
}
