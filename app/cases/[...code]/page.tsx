import { Relations } from 'components/Relations'
import { CaseIconDefinition } from 'icons/CaseIcon'
import { CompanyIconDefinition } from 'icons/CompanyIcon'
import { CountyIconDefinition } from 'icons/CountyIcon'
import { DocumentIconDefinition } from 'icons/DocumentIcon'
import { MunicipalityIconDefinition } from 'icons/MunicipalityIcon'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'
import { IconLink } from 'ui/IconLink'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from 'ui/Table'

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
      <div className="container pt-8 flex flex-col gap-2">
        <IconHeading
          icon={CaseIconDefinition}
          subtitle={c.name}
          title={c.code}
        />

        <Relations
          rows={[
            {
              icon: CompanyIconDefinition,
              href: `/companies/${c.company?.code}`,
              text: c.company?.name,
              show: !!c.company,
            },

            {
              icon: MunicipalityIconDefinition,
              href: `/municipalities/${documents[0].municipality.slug}`,
              text: documents[0].municipality.name,
              show: true,
            },

            {
              icon: CountyIconDefinition,
              href: `/counties/${documents[0].county.slug}`,
              text: documents[0].county.name,
              show: true,
            },
          ]}
        />

        <h2 className="font-heading scroll-m-20 text-xl font-semibold tracking-tight mt-8">
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
                    icon={DocumentIconDefinition}
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
