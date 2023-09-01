import { NextResponse } from 'next/server'

import { requireUser } from '../../../lib/authentication'
import prisma from '../../../lib/database'

export async function GET() {
  const user = await requireUser()
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const oldest = await prisma.chunk.findFirst({
    where: {
      ingested: null,
    },
    orderBy: {
      created: 'asc',
    },
  })

  if (!oldest) {
    return NextResponse.json([])
  }

  return NextResponse.json([
    {
      id: oldest.id,
    },
  ])
}
