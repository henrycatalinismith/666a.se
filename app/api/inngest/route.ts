import { inngest } from 'inngest/client'
// import { } from 'inngest/functions'
import { serve } from 'inngest/next'

export const { GET, POST, PUT } = serve(inngest, [
  // createScan,
  // createChunks,
  // completeChunk,
  // ingestChunk,
  // ingestStub,
])
