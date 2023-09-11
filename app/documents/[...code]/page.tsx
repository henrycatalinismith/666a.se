import { faCalendar, faFlag } from '@fortawesome/free-solid-svg-icons'
import { Relations } from 'components/Relations'
import { CaseIconDefinition } from 'entities/Case'
import { ChunkIconDefinition } from 'entities/Chunk'
import { CompanyIconDefinition } from 'entities/Company'
import { CountyIconDefinition } from 'entities/County'
import { DocumentIconDefinition } from 'entities/Document'
import { MunicipalityIconDefinition } from 'entities/Municipality'
import { ScanIconDefinition } from 'entities/Scan'
import { StubIconDefinition } from 'entities/Stub'
import { WorkplaceIconDefinition } from 'entities/Workplace'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

export default async function Document({ params }: any) {
  const user = await requireUser()
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
          scan: true,
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
              href: `/cases/${document.case.code}`,
              text: 'Case',
              subtitle: document.case.name,
              show: true,
            },

            {
              icon: WorkplaceIconDefinition,
              href: `/workplaces/${document.workplace?.code}`,
              text: 'Workplace',
              subtitle: document.workplace?.name as string,
              show: !!document.workplace,
            },

            {
              icon: CompanyIconDefinition,
              href: `/companies/${document.company?.code}`,
              text: 'Company',
              subtitle: document.company?.name as string,
              show: !!document.company,
            },

            {
              icon: MunicipalityIconDefinition,
              href: `/municipalities/${document.municipality.slug}`,
              text: 'Municipality',
              subtitle: document.municipality.name,
              show: true,
            },

            {
              icon: CountyIconDefinition,
              href: `/counties/${document.county.slug}`,
              text: 'County',
              subtitle: document.county.name,
              show: true,
            },

            {
              icon: StubIconDefinition,
              href: `/stubs/${document.stubs[0].id}`,
              text: 'Stub',
              subtitle: document.stubs[0].id,
              show: !!document.stubs[0],
            },

            {
              icon: ChunkIconDefinition,
              href: `/chunks/${document.stubs[0].chunk.id}`,
              text: 'Chunk',
              subtitle: document.stubs[0].chunk.id,
              show: true,
            },

            {
              icon: ScanIconDefinition,
              href: `/scans/${document.stubs[0].scan.id}`,
              text: 'Scan',
              subtitle: document.stubs[0].scan.id,
              show: true,
            },
          ]}
        />
      </div>
    </>
  )
}
