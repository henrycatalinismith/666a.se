import { faFile } from '@fortawesome/free-solid-svg-icons'
import { RoleName } from '@prisma/client'

import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

export default async function SearchResult({ params }: any) {
  const currentUser = await requireUser([RoleName.Developer])
  if (!currentUser) {
    return <></>
  }

  const searchResult = await prisma.searchResult.findFirstOrThrow({
    where: { id: params.id },
    include: { notifications: true },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={faFile}
          title="Search Result"
          subtitle={`${searchResult.id}`}
        />
      </div>
    </>
  )
}
