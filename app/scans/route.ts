import { NextResponse } from 'next/server'

import { requireUser } from '../../lib/authentication'
import prisma from '../../lib/database'
import { scanCounty } from '../../lib/ingestion'

export async function POST(request: Request) {
  const user = await requireUser()
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const body = await request.json()
  const slug = body.county

  const county = await prisma.county.findFirstOrThrow({
    where: {
      slug,
    },
  })

  const scan = await scanCounty(county)

  return NextResponse.json({
    id: scan.id,
  })
}
