import { faTag } from '@fortawesome/free-solid-svg-icons'
import { Relations } from 'components/Relations'
import { DocumentIconDefinition } from 'entities/Document'
import { WorkplaceIconDefinition } from 'entities/Workplace'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Workplace({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const workplace = await prisma.workplace.findFirstOrThrow({
    where: { code: params.code },
    include: { documents: { include: { case: true, type: true } } },
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-8">
        <IconHeading
          icon={WorkplaceIconDefinition}
          title={'Workplace'}
          subtitle={workplace.code}
        />

        <Relations
          rows={[
            {
              type: 'text',
              icon: faTag,
              text: 'Name',
              subtitle: workplace.name,
              show: true,
            },
          ]}
        />

        <LittleHeading>Documents</LittleHeading>

        <EntityList
          items={workplace.documents.map((document) => ({
            icon: DocumentIconDefinition,
            href: `/documents/${document.code}`,
            text: document.type.name,
            subtitle: document.date.toISOString().substring(0, 10),
            show: true,
          }))}
        />
      </div>
    </>
  )
}
