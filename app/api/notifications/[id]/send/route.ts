import { RoleName } from '@prisma/client'
import sgMail from '@sendgrid/mail'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { NextResponse } from 'next/server'

export async function POST(request: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const id = request.url!.match(/notifications\/(.+)\//)![1]
  const notification = await prisma.notification.findFirstOrThrow({
    where: { id },
    include: {
      subscription: {
        include: { user: true },
      },
    },
  })

  sgMail.setApiKey(process.env.SENDGRID_API_KEY!)

  const msg = {
    to: notification.subscription.user.email,
    from: 'hen@666a.se',
    subject: `New Arbetsmiljöverket document ${notification.documentCode}`,
    text: `Hey ${notification.subscription.user.name},

You're subscribed to email updates for Arbetsmiljöverket filings about company ${notification.companyCode}. A new public filing was made today for that company.

Case name: ${notification.caseName}.
Document type: ${notification.documentType}.
Document code: ${notification.documentCode}.

More information's available about it on Arbetsmiljöverket's website at the link below.
https://www.av.se/om-oss/sok-i-arbetsmiljoverkets-diarium/?id=${notification.documentCode}

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
}
