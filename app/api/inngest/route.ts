import { serve } from 'inngest/next'

import { inngest } from 'inngest/client'
// import { } from 'inngest/functions'

export const { GET, POST, PUT } = serve(inngest, [
  // createScan,
  // createChunks,
  // completeChunk,
  // ingestChunk,
  // ingestStub,
])
