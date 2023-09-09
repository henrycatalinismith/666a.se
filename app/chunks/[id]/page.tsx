import { Relations } from 'components/Relations'
import { ChunkIconDefinition } from 'icons/ChunkIcon'
import { CountyIconDefinition } from 'icons/CountyIcon'
import { ScanIconDefinition } from 'icons/ScanIcon'
import { StubIconDefinition } from 'icons/StubIcon'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Document({ params }: any) {
  const user = await requireUser()
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
          title={`${chunk.county.name} ${chunk.startDate
            ?.toISOString()
            .substring(0, 10)}`}
          subtitle={chunk.id}
        />

        <Relations
          rows={[
            {
              icon: ScanIconDefinition,
              href: `/scans/${chunk.scan.id}`,
              text: `${chunk.scan.county.name} ${chunk.scan.startDate
                ?.toISOString()
                .substring(0, 10)}`,
              show: true,
            },

            {
              icon: CountyIconDefinition,
              href: `/counties/${chunk.county.slug}`,
              text: chunk.county.name,
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
          }))}
        />
      </div>
    </>
  )
}
