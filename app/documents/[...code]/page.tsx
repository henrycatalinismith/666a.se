import { faFileLines, faPeopleGroup } from '@fortawesome/free-solid-svg-icons'
import { IconHeading } from 'components/IconHeading'
import { IconLink } from 'components/IconLink'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'

export default async function Document({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const document = await prisma.document.findFirstOrThrow({
    where: { code: params.code.join('/') },
    include: { company: true, type: true, workplace: true },
  })

  return (
    <>
      <div className="container pt-8">
        <div className="space-y-3">
          <IconHeading icon={faFileLines}>{document.code}</IconHeading>
          <p className="text-lg text-muted-foreground">{document.type.name}</p>
        </div>

        {document.company && (
          <p className="pt-8">
            <IconLink
              icon={faPeopleGroup}
              href={`/companies/${document.company.code}`}
            >
              {document.company.name}
            </IconLink>
          </p>
        )}

        {document.workplace && (
          <p className="pt-8">
            <IconLink
              icon={faPeopleGroup}
              href={`/workplaces/${document.workplace.code}`}
            >
              {document.workplace.name}
            </IconLink>
          </p>
        )}
      </div>
    </>
  )
}
