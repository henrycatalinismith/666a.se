import { RoleName } from '@prisma/client'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { NextResponse } from 'next/server'

export async function DELETE(request: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  console.log(request.url)
  const id = request.url!.match(/users\/(.+)/)![1]
  await prisma.user.findFirstOrThrow({
    where: { id },
  })

  await prisma.user.delete({
    where: { id },
  })

  return NextResponse.json([
    {
      lol: true,
    },
  ])
}
