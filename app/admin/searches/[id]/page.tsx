import { faCalendarDay, faGauge, faHashtag, faQuestion, faQuoteLeft } from '@fortawesome/free-solid-svg-icons'
import { RoleName } from '@prisma/client'
import { Relations } from 'components/Relations'

import { SearchIconDefinition } from 'entities/Search'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import _ from 'lodash'
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

        <Relations
          rows={[{
            icon: faGauge,
            type: 'text',
            text: 'Status',
            subtitle: search.status,
            show: true,
          },{
            icon: faQuoteLeft,
            type: 'text',
            text: 'Hit Count',
            subtitle: search.hitCount!,
            show: true,
          }]}
        />

        <LittleHeading>Parameters</LittleHeading>

        <Relations
          rows={search.parameters.map(parameter => ({
            icon: _.get({
              'FromDate': faCalendarDay,
              'ToDate': faCalendarDay,
              'OrganisationNumber': faHashtag,
            }, parameter.name, faQuestion),
            type: 'text',
            text: parameter.name,
            subtitle: parameter.value,
            show: true,
          }))}
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
