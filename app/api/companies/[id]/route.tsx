import { ErrorStatus, RoleName } from '@prisma/client'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { NextResponse } from 'next/server'

export async function PUT(request: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const id = request.url!.match(/companies\/(.+)/)![1]
  await prisma.company.findFirstOrThrow({
    where: { id },
  })

  const { name } = await request.json()
  await prisma.company.update({
    data: { name },
    where: { id },
  })

  return NextResponse.json([
    {
      status: 'success',
    },
  ])
}
