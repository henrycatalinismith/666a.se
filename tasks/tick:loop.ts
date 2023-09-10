import { createTick } from '../lib/ingestion'

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms))
}

;(async () => {
  for (let i = 0; i < 10000; i += 1) {
    const tick = await createTick()
    console.log(tick)
    await sleep(5000)
  }

  process.exit(0)
})()
