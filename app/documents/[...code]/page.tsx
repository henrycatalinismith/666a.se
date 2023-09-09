import { faFileLines, faPeopleGroup } from '@fortawesome/free-solid-svg-icons'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'
import { IconLink } from 'ui/IconLink'

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
        <IconHeading
          icon={faFileLines}
          title={document.code}
          subtitle={document.type.name}
        />

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
