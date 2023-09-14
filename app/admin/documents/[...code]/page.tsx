import { faCalendar, faFlag } from '@fortawesome/free-solid-svg-icons'
import { RoleName } from '@prisma/client'
import { Relations } from 'components/Relations'
import { CaseIconDefinition } from 'entities/Case'
import { ChunkIconDefinition } from 'entities/Chunk'
import { CompanyIconDefinition } from 'entities/Company'
import { CountyIconDefinition } from 'entities/County'
import { DocumentIconDefinition } from 'entities/Document'
import { MunicipalityIconDefinition } from 'entities/Municipality'
import { StubIconDefinition } from 'entities/Stub'
import { WorkplaceIconDefinition } from 'entities/Workplace'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

export default async function Document({ params }: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const document = await prisma.document.findFirstOrThrow({
    where: { code: params.code.join('/') },
    include: {
      case: true,
      company: true,
      county: true,
      municipality: true,
      type: true,
      workplace: true,
      stubs: {
        include: {
          chunk: true,
        },
      },
    },
  })

  return (
    <>
      <div className="flex flex-col container pt-8 gap-8">
        <IconHeading
          icon={DocumentIconDefinition}
          title="Document"
          subtitle={document.code}
        />

        <Relations
          rows={[
            {
              type: 'text',
              icon: faFlag,
              text: 'Type',
              subtitle: document.type.name,
              show: true,
            },

            {
              type: 'text',
              icon: faCalendar,
              text: 'Date',
              subtitle: document.date.toISOString().substring(0, 10),
              show: true,
            },

            {
              icon: CaseIconDefinition,
              href: `/admin/cases/${document.case.code}`,
              text: 'Case',
              subtitle: document.case.name,
              show: true,
            },

            {
              icon: WorkplaceIconDefinition,
              href: `/admin/workplaces/${document.workplace?.code}`,
              text: 'Workplace',
              subtitle: document.workplace?.name as string,
              show: !!document.workplace,
            },

            {
              icon: CompanyIconDefinition,
              href: `/admin/companies/${document.company?.code}`,
              text: 'Company',
              subtitle: document.company?.name as string,
              show: !!document.company,
            },

            {
              icon: MunicipalityIconDefinition,
              href: `/admin/municipalities/${document.municipality?.slug}`,
              text: 'Municipality',
              subtitle: document.municipality?.name as string,
              show: !!document.municipality,
            },

            {
              icon: CountyIconDefinition,
              href: `/admin/counties/${document.county?.slug}`,
              text: 'County',
              subtitle: document.county?.name as string,
              show: !!document.county,
            },

            {
              icon: StubIconDefinition,
              href: `/admin/stubs/${document.stubs[0].id}`,
              text: 'Stub',
              subtitle: document.stubs[0].id,
              show: !!document.stubs[0],
            },

            {
              icon: ChunkIconDefinition,
              href: `/admin/chunks/${document.stubs[0].chunk.id}`,
              text: 'Chunk',
              subtitle: document.stubs[0].chunk.id,
              show: true,
            },
          ]}
        />
      </div>
    </>
  )
}
