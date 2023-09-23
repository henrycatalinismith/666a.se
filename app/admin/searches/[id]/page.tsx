import { RoleName } from '@prisma/client'

import { SearchIconDefinition } from 'entities/Search'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Search({ params }: any) {
  const currentUser = await requireUser([RoleName.Developer])
  if (!currentUser) {
    return <></>
  }

  const search = await prisma.search.findFirstOrThrow({
    where: { id: params.id },
    include: { parameters: true, results: true },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={SearchIconDefinition}
          title="Search"
          subtitle={`${search.id}`}
        />

        <LittleHeading>Results</LittleHeading>

        <EntityList
          items={search.results.map((result) => ({
            icon: SearchIconDefinition,
            href: `/admin/search-results/${result.id}`,
            text: result.documentType,
            subtitle: result.caseName,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
