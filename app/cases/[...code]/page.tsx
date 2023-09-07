import {
  faBoxArchive,
  faCity,
  faEarthEurope,
  faFileLines,
  faPeopleGroup,
} from '@fortawesome/free-solid-svg-icons'

import { IconHeading } from '../../../components/IconHeading'
import { IconLink } from '../../../components/IconLink'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '../../../components/Table'
import { requireUser } from '../../../lib/authentication'
import prisma from '../../../lib/database'

export default async function Case({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const c = await prisma.case.findFirstOrThrow({
    where: { code: params.code.join('/') },
    include: { company: true },
  })

  const documents = await prisma.document.findMany({
    where: { caseId: c.id },
    include: { county: true, municipality: true, type: true },
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-8">
        <div className="space-y-3">
          <IconHeading icon={faBoxArchive}>{c.code}</IconHeading>
          <p className="text-lg text-muted-foreground">{c!.name}</p>
        </div>

        <div>
          {c.company && (
            <p className="">
              <IconLink
                icon={faPeopleGroup}
                href={`/companies/${c.company.code}`}
              >
                {c.company.name}
              </IconLink>
            </p>
          )}

          {documents[0].county && (
            <p className="">
              <IconLink
                icon={faEarthEurope}
                href={`/counties/${documents[0].county.slug}`}
              >
                {documents[0].county.name}
              </IconLink>
            </p>
          )}

          {documents[0].municipality && (
            <p className="">
              <IconLink
                icon={faCity}
                href={`/municipalities/${documents[0].municipality.slug}`}
              >
                {documents[0].municipality.name}
              </IconLink>
            </p>
          )}
        </div>

        <h2 className="font-heading scroll-m-20 text-xl font-semibold tracking-tight">
          Documents
        </h2>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="text-left">ID</TableHead>
              <TableHead className="text-left">Type</TableHead>
              <TableHead className="text-left">Filing ID</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {documents.map((document: any) => (
              <TableRow key={document.id}>
                <TableCell>
                  <IconLink
                    icon={faFileLines}
                    href={`/documents/${document.code}`}
                  >
                    {document.code}
                  </IconLink>
                </TableCell>
                <TableCell>{document.type.name}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </>
  )
}
