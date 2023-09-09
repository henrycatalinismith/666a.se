import { Relations } from 'components/Relations'
import { ChunkIconDefinition } from 'icons/ChunkIcon'
import { ScanIconDefinition } from 'icons/ScanIcon'
import { StubIconDefinition } from 'icons/StubIcon'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

export default async function Document({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const stub = await prisma.stub.findFirstOrThrow({
    where: { id: params.id },
    include: {
      document: true,
      chunk: { include: { county: true } },
      scan: { include: { county: true } },
    },
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-8">
        <IconHeading
          icon={StubIconDefinition}
          title={stub.documentCode}
          subtitle={stub.created
            .toISOString()
            .substring(0, 19)
            .replace('T', ' ')}
        />

        <Relations
          rows={[
            {
              icon: ChunkIconDefinition,
              href: `/chunks/${stub.chunk.id}`,
              text: `${stub.chunk.county.name} ${stub.chunk.startDate
                ?.toISOString()
                .substring(0, 10)}`,
              show: true,
            },

            {
              icon: ScanIconDefinition,
              href: `/scans/${stub.scan.id}`,
              text: `${stub.scan.county.name} ${stub.scan.startDate
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
