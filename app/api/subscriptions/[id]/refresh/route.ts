import { NotificationEmailStatus, RoleName, SearchStatus } from '@prisma/client'
import { NextResponse } from 'next/server'

import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { searchDiarium } from 'lib/diarium'

export async function POST(request: any) {
  const user = await requireUser([RoleName.Developer])
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

  const search = await prisma.search.create({
    data: {
      status: SearchStatus.Pending,
    },
  })

  const refresh = await prisma.refresh.create({
    data: {
      subscriptionId: subscription.id,
      searchId: search.id,
    },
  })

  await prisma.search.update({
    data: { status: SearchStatus.Active },
    where: { id: search.id },
  })

  const today = new Date('2023-08-30')
  await prisma.searchParameter.createMany({
    data: [
      {
        searchId: search.id,
        name: 'FromDate',
        value: today.toISOString().substring(0, 10),
      },
      {
        searchId: search.id,
        name: 'ToDate',
        value: today.toISOString().substring(0, 10),
      },
      {
        searchId: search.id,
        name: 'OrganisationNumber',
        value: subscription.companyCode,
      },
    ],
  })

  let result

  try {
    result = await searchDiarium({
      FromDate: today.toISOString().substring(0, 10),
      ToDate: today.toISOString().substring(0, 10),
      OrganisationNumber: subscription.companyCode,
    })
  } catch (e) {
    await prisma.search.update({
      data: { status: SearchStatus.Error },
      where: { id: search.id },
    })
    throw e
  }

  await prisma.search.update({
    data: {
      hitCount: result.hitCount,
      status: SearchStatus.Success,
    },
    where: { id: search.id },
  })

  await prisma.searchResult.createMany({
    data: result.rows.map((row) => ({
      searchId: search.id,
      caseName: row.caseName,
      companyName: row.companyName,
      documentCode: row.documentCode,
      documentDate: row.documentDate,
      documentType: row.documentType,
    })),
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
        emailStatus: NotificationEmailStatus.Pending,
        caseName: row.caseName,
        documentCode: row.documentCode,
        documentDate: row.documentDate,
        documentType: row.documentType,
      },
    })
  }

  return NextResponse.json({
    success: true,
  })
}
