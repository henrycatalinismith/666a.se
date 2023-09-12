import { RoleName } from '@prisma/client'
import { CountyIconDefinition } from 'entities/County'
import { MunicipalityIconDefinition } from 'entities/Municipality'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function County({ params }: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const county = await prisma.county.findFirstOrThrow({
    where: { slug: params.slug },
    include: { municipalities: true },
  })

  return (
    <>
      <div className="container mx-auto w-sbm pt-8 flex flex-col gap-8">
        <IconHeading
          icon={CountyIconDefinition}
          title={'County'}
          subtitle={county.name}
        />

        <LittleHeading>Municipalities</LittleHeading>

        <EntityList
          items={county.municipalities.map((municipality) => ({
            icon: MunicipalityIconDefinition,
            href: `/municipalities/${municipality.slug}`,
            text: municipality.name,
            subtitle: municipality.code,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
