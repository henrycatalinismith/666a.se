import { faCalendar } from '@fortawesome/free-solid-svg-icons'
import { RoleName } from '@prisma/client'
import { Relations } from 'components/Relations'
import { ChunkIconDefinition } from 'entities/Chunk'
import { CountyIconDefinition } from 'entities/County'
import { ScanIconDefinition } from 'entities/Scan'
import { StubIconDefinition } from 'entities/Stub'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Document({ params }: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const chunk = await prisma.chunk.findFirstOrThrow({
    where: { id: params.id },
    include: {
      county: true,
      scan: { include: { county: true } },
      stubs: { include: { document: true } },
    },
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-8">
        <IconHeading
          icon={ChunkIconDefinition}
          title="Chunk"
          subtitle={chunk.id}
        />

        <Relations
          rows={[
            {
              type: 'text',
              icon: faCalendar,
              text: 'Start date',
              subtitle: chunk.startDate
                ?.toISOString()
                .substring(0, 10) as string,
              show: true,
            },

            {
              icon: ScanIconDefinition,
              href: `/scans/${chunk.scan.id}`,
              text: 'Scan',
              subtitle: chunk.scan.id,
              show: true,
            },

            {
              icon: CountyIconDefinition,
              href: `/counties/${chunk.county.slug}`,
              text: 'County',
              subtitle: chunk.county.name,
              show: true,
            },
          ]}
        />

        <LittleHeading>Stubs</LittleHeading>

        <EntityList
          items={chunk.stubs.map((stub) => ({
            icon: StubIconDefinition,
            href: `/stubs/${stub.id}`,
            text: stub.documentType,
            subtitle: stub.documentCode,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
