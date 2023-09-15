import { inngest } from 'inngest/client'
import {
  createScan,
  createChunks,
  ingestChunk,
  ingestStub,
  completeChunk,
} from 'inngest/functions'
import { serve } from 'inngest/next'

export const { GET, POST, PUT } = serve(inngest, [
  createScan,
  createChunks,
  completeChunk,
  ingestChunk,
  ingestStub,
])
