import { faCube } from '@fortawesome/free-solid-svg-icons'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

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
        <IconHeading
          icon={faCube}
          title={stub.documentCode}
          subtitle={stub.created
            .toISOString()
            .substring(0, 19)
            .replace('T', ' ')}
        />
      </div>
    </>
  )
}
