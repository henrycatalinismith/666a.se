import { faTag } from '@fortawesome/free-solid-svg-icons'
import { RoleName } from '@prisma/client'
import {
  IconDefinitionList,
  IconDefinitionListDefinition,
  IconDefinitionListIcon,
  IconDefinitionListItem,
  IconDefinitionListRow,
  IconDefinitionListTerm,
} from 'components/IconDefinitionList'
import { Relations } from 'components/Relations'
import { CaseIconDefinition } from 'entities/Case'
import { CompanyIconDefinition } from 'entities/Company'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Company({ params }: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const company = await prisma.company.findFirstOrThrow({
    where: { code: params.code },
  })
  const cases = await prisma.case.findMany({
    where: { companyId: company.id },
    include: { documents: { orderBy: { date: 'asc' } } },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-2">
        <IconHeading
          icon={CompanyIconDefinition}
          title="Company"
          subtitle={company.code}
        />

        <IconDefinitionList>
          <IconDefinitionListRow editable>
            <IconDefinitionListIcon icon={faTag} />
            <IconDefinitionListItem>
              <IconDefinitionListTerm>Name</IconDefinitionListTerm>
              <IconDefinitionListDefinition>
                {company.name}
              </IconDefinitionListDefinition>
            </IconDefinitionListItem>
          </IconDefinitionListRow>
        </IconDefinitionList>

        <Relations
          rows={[
            {
              type: 'text',
              icon: faTag,
              text: 'Name',
              subtitle: company.name,
              show: true,
            },
          ]}
        />

        <LittleHeading>Cases</LittleHeading>

        <EntityList
          items={cases.map((c) => ({
            icon: CaseIconDefinition,
            href: `/cases/${c.code}`,
            text: c.name,
            subtitle: c.documents[0].date.toISOString().substring(0, 10),
            show: true,
          }))}
        />
      </div>
    </>
  )
}
