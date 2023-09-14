import { RoleName } from '@prisma/client'
import { ResolveErrorButton } from 'components/ResolveErrorButton'
import { ErrorIconDefinition } from 'entities/Error'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

export default async function Error({ params }: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const error = await prisma.error.findFirstOrThrow({
    where: { id: params.id },
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-2">
        <IconHeading
          icon={ErrorIconDefinition}
          title={`${error.message.split('\n')[0]}`}
          subtitle={error.id}
        />
      </div>

      <pre className="container overflow-hidden bg-gray-200 w-full flex p-8 my-8 text-ellipsis">
        <code className="overflow-hidden">{error.stack}</code>
      </pre>

      <div className="container flex flex-col gap-2">
        <ResolveErrorButton error={error} />
      </div>
    </>
  )
}
