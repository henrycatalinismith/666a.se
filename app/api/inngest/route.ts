import { serve } from 'inngest/next'

import { inngest } from 'lib/inngest'
// import { } from 'inngest/functions'

export const { GET, POST, PUT } = serve(inngest, [
  // createScan,
  // createChunks,
  // completeChunk,
  // ingestChunk,
  // ingestStub,
])
