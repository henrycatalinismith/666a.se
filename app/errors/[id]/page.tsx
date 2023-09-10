import { ResolveErrorButton } from 'components/ResolveErrorButton'
import { ErrorIconDefinition } from 'entities/Error'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

export default async function Error({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const error = await prisma.error.findFirstOrThrow({
    where: { id: params.id },
    include: {},
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-2">
        <IconHeading
          icon={ErrorIconDefinition}
          title={`${error.message.split('\n')[0]}`}
          subtitle={error.id}
        />

        <pre className="overflow-hidden">
          <code>{error.stack}</code>
        </pre>

        <ResolveErrorButton error={error} />
      </div>
    </>
  )
}
