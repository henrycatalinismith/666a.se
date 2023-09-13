import { faTag } from '@fortawesome/free-solid-svg-icons'
import { RoleName } from '@prisma/client'
import { Relations } from 'components/Relations'
import { CaseIconDefinition } from 'entities/Case'
import { CompanyIconDefinition } from 'entities/Company'
import { CountyIconDefinition } from 'entities/County'
import { DocumentIconDefinition } from 'entities/Document'
import { MunicipalityIconDefinition } from 'entities/Municipality'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Case({ params }: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const c = await prisma.case.findFirstOrThrow({
    where: { code: params.code.join('/') },
    include: {
      company: true,
      documents: { include: { county: true, municipality: true, type: true } },
    },
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-2">
        <IconHeading icon={CaseIconDefinition} title="Case" subtitle={c.code} />

        <Relations
          rows={[
            {
              type: 'text',
              icon: faTag,
              text: 'Name',
              subtitle: c.name,
              show: true,
            },

            {
              icon: CompanyIconDefinition,
              href: `/companies/${c.company?.code}`,
              text: 'Company',
              subtitle: c.company?.name as string,
              show: !!c.company,
            },

            {
              icon: MunicipalityIconDefinition,
              href: `/municipalities/${c.documents[0].municipality?.slug}`,
              text: 'Municipality',
              subtitle: c.documents[0].municipality?.name as string,
              show: !!c.documents[0].municipality,
            },

            {
              icon: CountyIconDefinition,
              href: `/counties/${c.documents[0].county?.slug}`,
              text: 'County',
              subtitle: c.documents[0].county?.name as string,
              show: !!c.documents[0].county,
            },
          ]}
        />

        <LittleHeading>Documents</LittleHeading>

        <EntityList
          items={c.documents.map((document) => ({
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
