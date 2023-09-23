import { RoleName } from '@prisma/client'

import { SearchIconDefinition } from 'entities/Search'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'

export default async function Searches() {
  const user = await requireUser([RoleName.Developer])
  if (!user) {
    return <></>
  }

  const searches = await prisma.search.findMany({
    orderBy: {
      created: 'desc',
    },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={SearchIconDefinition}
          title="Searches"
          subtitle={`${searches.length}`}
        />

        <EntityList
          items={searches.map((search) => ({
            icon: SearchIconDefinition,
            href: `/admin/searches/${search.id}`,
            subtitle: search.status,
            text: search.id,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
