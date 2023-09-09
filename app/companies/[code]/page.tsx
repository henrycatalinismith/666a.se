import { CaseIconDefinition } from 'icons/CaseIcon'
import { CompanyIconDefinition } from 'icons/CompanyIcon'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Company({ params }: any) {
  const user = await requireUser()
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
          title={company.name}
          subtitle={company.code}
        />

        <LittleHeading>Cases</LittleHeading>

        <EntityList
          items={cases.map((c) => ({
            icon: CaseIconDefinition,
            href: `/cases/${c.code}`,
            text: c.name,
            subtitle: c.documents[0].date.toISOString().substring(0, 10),
          }))}
        />
      </div>
    </>
  )
}
