import { NotificationEmailStatus, RoleName } from '@prisma/client'
import { NextResponse } from 'next/server'

import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { searchDiarium } from 'lib/diarium'

export async function POST(request: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const id = request.url!.match(/subscriptions\/(.+)\//)![1]
  const subscription = await prisma.subscription.findFirstOrThrow({
    where: { id },
    include: {
      user: true,
    },
  })

  const refresh =await prisma.refresh.create({
    data: {
      subscriptionId: subscription.id
    }
  })

  const today = new Date()

  const result = await searchDiarium({
    FromDate: today.toISOString().substring(0, 10),
    ToDate: today.toISOString().substring(0, 10),
    OrganisationNumber: subscription.companyCode,
  })

  console.log(result.hitCount)
  console.log(result.rows.length)
  for (const row of result.rows) {
    await prisma.notification.create({
      data: {
        subscriptionId: subscription.id,
        refreshId: refresh.id,
        userId: subscription.user.id,
        companyCode: subscription.companyCode,
        emailStatus: NotificationEmailStatus.PENDING,
        caseName: row.caseName,
        documentCode: row.documentCode,
        documentDate: row.documentDate,
        documentType: row.documentType,
      },
    })
  }

  return NextResponse.json({
    success: true
  })
}
