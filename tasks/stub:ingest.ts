import { ingestStub } from '../lib/ingestion'
;(async () => {
  await ingestStub(process.argv[2])
})()
