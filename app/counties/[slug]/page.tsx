import { faCity, faEarthEurope } from '@fortawesome/free-solid-svg-icons'
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

export default async function County({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const county = await prisma.county.findFirstOrThrow({
    where: { slug: params.slug },
    include: { municipalities: true },
  })

  return (
    <>
      <div className="container mx-auto w-sbm pt-8">
        <div className="space-y-3">
          <IconHeading icon={faEarthEurope} title={county.name} subtitle="" />
          <p className="text-lg text-muted-foreground">{county.code}</p>
        </div>

        <h2 className="pt-8 font-heading mt-8 scroll-m-20 text-xl font-semibold tracking-tight">
          Municipalities
        </h2>

        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>?</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {county.municipalities.map((m: any) => (
              <TableRow key={m.id}>
                <TableCell>
                  <IconLink href={`/municipalities/${m.slug}`} icon={faCity}>
                    {m.name}
                  </IconLink>
                </TableCell>
                <TableCell>{m.code}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </>
  )
}
