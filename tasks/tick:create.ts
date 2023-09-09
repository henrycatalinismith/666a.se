import { createTick } from 'lib/ingestion'
;(async () => {
  console.log('tick')
  const tick = await createTick()
  console.log(tick)
  process.exit(0)
})()
