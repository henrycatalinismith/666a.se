import { ChunkStatus, StubStatus } from '@prisma/client'

import prisma from '../lib/database'
import { createDocument, fetchDocument } from '../lib/ingestion'

function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(() => resolve(), ms))
}

;(async () => {
  const stubs = await prisma.stub.findMany({
    where: { status: { in: [StubStatus.PENDING] } },
    orderBy: { created: 'asc' },
    include: { scan: true },
  })

  for (const stub of stubs) {
    console.log(`${stub.id} ${stub.documentCode}`)

    await prisma.$transaction(
      async (tx) => {
        const d = await tx.document.findFirst({
          where: { code: stub.documentCode },
        })
        if (d) {
          console.log('oops')
          await tx.stub.update({
            data: { status: StubStatus.SUCCESS, documentId: d.id },
            where: { id: stub.id },
          })
          return
        }

        const diariumDocument = await fetchDocument(stub.documentCode)
        const doc = await createDocument(diariumDocument, tx)
        console.log(doc.id)

        await tx.stub.update({
          data: { status: StubStatus.SUCCESS, documentId: doc.id },
          where: { id: stub.id },
        })
      },
      {
        timeout: 15000,
      }
    )

    await delay(3000)
  }

  process.exit(0)
})()
