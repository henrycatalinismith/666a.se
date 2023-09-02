import prisma from '../lib/database'
import { scanCounty } from '../lib/scan'
;(async () => {
  const county = await prisma.county.findFirstOrThrow({
    where: { slug: process.argv[2] },
  })
  await scanCounty(county.id)
})()
