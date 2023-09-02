import { createTick } from '../lib/tick'

// import prisma from '../lib/database'
;(async () => {
  console.log('tick')
  const tick = await createTick()
  console.log(tick)
  process.exit(0)
})()
