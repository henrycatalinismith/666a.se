import { faCalendar, faFlag, faTag } from '@fortawesome/free-solid-svg-icons'
import { RoleName } from '@prisma/client'
import { Relations } from 'components/Relations'
import { ChunkIconDefinition } from 'entities/Chunk'
import { DocumentIconDefinition } from 'entities/Document'
import { ScanIconDefinition } from 'entities/Scan'
import { StubIconDefinition } from 'entities/Stub'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

export default async function Document({ params }: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const stub = await prisma.stub.findFirstOrThrow({
    where: { id: params.id },
    include: {
      document: { include: { type: true } },
      chunk: true,
      scan: true,
    },
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-8">
        <IconHeading
          icon={StubIconDefinition}
          title={'Stub'}
          subtitle={stub.id}
        />

        <Relations
          rows={[
            {
              type: 'text',
              icon: faCalendar,
              text: 'Document date',
              subtitle: stub.documentDate
                ?.toISOString()
                .substring(0, 10) as string,
              show: true,
            },

            {
              type: 'text',
              icon: faFlag,
              text: 'Document type',
              subtitle: stub.documentType,
              show: true,
            },

            {
              type: 'text',
              icon: faTag,
              text: 'Case name',
              subtitle: stub.caseName,
              show: true,
            },

            {
              icon: DocumentIconDefinition,
              href: `/documents/${stub.document?.code}`,
              text: 'Document',
              subtitle: stub.document?.type.name as string,
              show: !!stub.document,
            },

            {
              icon: ChunkIconDefinition,
              href: `/chunks/${stub.chunk.id}`,
              text: 'Chunk',
              subtitle: stub.chunk.id,
              show: true,
            },

            {
              icon: ScanIconDefinition,
              href: `/scans/${stub.scan.id}`,
              text: 'Scan',
              subtitle: stub.scan.id,
              show: true,
            },
          ]}
        />
      </div>
    </>
  )
}
