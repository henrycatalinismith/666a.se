import { RoleName } from '@prisma/client'
import { requireUser } from 'lib/authentication'
import { NextResponse } from 'next/server'

// import prisma from 'lib/database'

export async function POST() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  return NextResponse.json([
    {
      lol: true,
    },
  ])
}
