import { Relations } from 'components/Relations'
import { CaseIconDefinition } from 'icons/CaseIcon'
import { ChunkIconDefinition } from 'icons/ChunkIcon'
import { CompanyIconDefinition } from 'icons/CompanyIcon'
import { CountyIconDefinition } from 'icons/CountyIcon'
import { DocumentIconDefinition } from 'icons/DocumentIcon'
import { MunicipalityIconDefinition } from 'icons/MunicipalityIcon'
import { StubIconDefinition } from 'icons/StubIcon'
import { WorkplaceIconDefinition } from 'icons/WorkplaceIcon'
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
          chunk: {
            include: { county: true },
          },
        },
      },
    },
  })

  return (
    <>
      <div className="flex flex-col container pt-8 gap-2">
        <IconHeading
          icon={DocumentIconDefinition}
          title={document.code}
          subtitle={document.type.name}
        />

        <Relations
          rows={[
            {
              icon: CaseIconDefinition,
              href: `/cases/${document.case.code}`,
              text: document.case.name,
              show: true,
            },

            {
              icon: WorkplaceIconDefinition,
              href: `/workplaces/${document.workplace?.code}`,
              text: document.workplace?.name,
              show: !!document.workplace,
            },

            {
              icon: CompanyIconDefinition,
              href: `/companies/${document.company?.code}`,
              text: document.company?.name,
              show: !!document.company,
            },

            {
              icon: MunicipalityIconDefinition,
              href: `/municipalities/${document.municipality.slug}`,
              text: document.municipality.name,
              show: true,
            },

            {
              icon: CountyIconDefinition,
              href: `/counties/${document.county.slug}`,
              text: document.county.name,
              show: true,
            },

            {
              icon: StubIconDefinition,
              href: `/stubs/${document.stubs[0].id}`,
              text: document.stubs[0].documentCode,
              show: !!document.stubs[0],
            },

            {
              icon: ChunkIconDefinition,
              href: `/chunks/${document.stubs[0].chunk.id}`,
              text: `${
                document.stubs[0].chunk.county.name
              } ${document.stubs[0].chunk.startDate
                ?.toISOString()
                .substring(0, 10)}`,
              show: true,
            },
          ]}
        />
      </div>
    </>
  )
}
