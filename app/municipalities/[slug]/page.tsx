import { Relations } from 'components/Relations'
import { CountyIconDefinition } from 'entities/County'
import { DocumentIconDefinition } from 'entities/Document'
import { MunicipalityIconDefinition } from 'entities/Municipality'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Municipality({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const municipality = await prisma.municipality.findFirstOrThrow({
    where: { slug: params.slug },
    include: { county: true },
  })

  const documents = await prisma.document.findMany({
    where: { municipalityId: municipality.id },
    include: { case: true, company: true, type: true },
    orderBy: { created: 'desc' },
    take: 64,
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-8">
        <IconHeading
          icon={MunicipalityIconDefinition}
          title={'Municipality'}
          subtitle={municipality.name}
        />

        <Relations
          rows={[
            {
              icon: CountyIconDefinition,
              href: `/counties/${municipality.county.slug}`,
              text: 'County',
              subtitle: municipality.county.name,
              show: true,
            },
          ]}
        />

        <LittleHeading>Documents</LittleHeading>

        <EntityList
          items={documents.map((document) => ({
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
