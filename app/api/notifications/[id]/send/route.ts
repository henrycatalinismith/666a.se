import { RoleName } from '@prisma/client'
import sgMail from '@sendgrid/mail'
import { NextResponse } from 'next/server'

import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'

export async function POST(request: any) {
  const user = await requireUser([RoleName.Developer])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const id = request.url!.match(/notifications\/(.+)\//)![1]
  const notification = await prisma.notification.findFirstOrThrow({
    where: { id },
    include: {
      searchResult: true,
      subscription: {
        include: { user: true },
      },
    },
  })

  sgMail.setApiKey(process.env.SENDGRID_API_KEY!)

  const msg = {
    to: notification.subscription.user.email,
    from: 'hen@666a.se',
    subject: `New Arbetsmiljöverket document ${notification.searchResult.documentCode}`,
    text: `Hey ${notification.subscription.user.name},

You're subscribed to email updates for Arbetsmiljöverket filings about company ${notification.subscription.companyCode}. A new public filing was made today for that company.

Case name: ${notification.searchResult.caseName}.
Document type: ${notification.searchResult.documentType}.
Document code: ${notification.searchResult.documentCode}.

More information's available about it on Arbetsmiljöverket's website at the link below.
https://www.av.se/om-oss/sok-i-arbetsmiljoverkets-diarium/?id=${notification.searchResult.documentCode}

You can email Arbetsmiljöverket for a free copy of the document if it sounds like something you need to read.

If you don't need these notifications any more you can unsubscribe at the link below.
https://666a.se/unsubscribe/e2a10b0f-bcbe-4977-9d38-5ea1d6b26c15
`,
  }

  try {
    await sgMail.send(msg)
    console.log('Sent')
  } catch (error) {
    console.error(error)
  }

  return NextResponse.json({
    success: true,
  })
}
