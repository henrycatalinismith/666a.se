import Link from 'next/link'

import { requireUser } from '../../../lib/authentication'
import prisma from '../../../lib/database'

export default async function Document({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const document = await prisma.document.findFirstOrThrow({
    where: { code: params.code.join('/') },
    include: { company: true, type: true },
  })

  return (
    <>
      <div className="container pt-8">
        <div className="space-y-3">
          <h1 className="scroll-m-20 text-4xl font-bold tracking-tight">
            {document.code}
          </h1>
          <p className="text-lg text-muted-foreground">{document.type.name}</p>
        </div>

        {document.company && (
          <p className="pt-8">
            <Link href={`/companies/${document.company.code}`}>
              {document.company.name}
            </Link>
          </p>
        )}
      </div>
    </>
  )
}
