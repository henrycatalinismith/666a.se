import { inngest } from './client'

export const createScan = inngest.createFunction(
  { name: 'Create scan' },
  { event: '666a/day.created' },
  async ({ event, step }) => {
    await step.run('Create scan', async () =>
      fetch(`http://192.168.86.195:3000/api/days/${event.data.id}/scan`, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          Cookie: `session=${process.env.SESSION_SECRET}`,
          'Content-Type': 'application/json',
        },
      })
    )
  }
)

export const createChunks = inngest.createFunction(
  { name: 'Create chunks' },
  { event: '666a/scan.created' },
  async ({ event, step }) => {
    await step.run('Create chunks', async () =>
      fetch(`http://192.168.86.195:3000/api/scans/${event.data.id}/chunks`, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          Cookie: `session=${process.env.SESSION_SECRET}`,
          'Content-Type': 'application/json',
        },
      })
    )
  }
)

export const ingestChunk = inngest.createFunction(
  { name: 'Ingest chunk' },
  { event: '666a/chunk.started' },
  async ({ event, step }) => {
    await step.run('Ingest chunk', async () =>
      fetch(`http://192.168.86.195:3000/api/chunks/${event.data.id}/ingest`, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          Cookie: `session=${process.env.SESSION_SECRET}`,
          'Content-Type': 'application/json',
        },
      })
    )
  }
)

export const completeChunk = inngest.createFunction(
  { name: 'Complete chunk' },
  { event: '666a/chunk.completed' },
  async ({ event, step }) => {
    await step.run('Complete completed', async () =>
      fetch(`http://192.168.86.195:3000/api/chunks/${event.data.id}/complete`, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          Cookie: `session=${process.env.SESSION_SECRET}`,
          'Content-Type': 'application/json',
        },
      })
    )
  }
)

export const startChunk = inngest.createFunction(
  { name: 'Start chunk' },
  { event: '666a/chunk.started' },
  async ({ event, step }) => {
    await step.run('Complete completed', async () =>
      fetch(`http://192.168.86.195:3000/api/chunks/${event.data.id}/ingest`, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          Cookie: `session=${process.env.SESSION_SECRET}`,
          'Content-Type': 'application/json',
        },
      })
    )
  }
)

export const ingestStub = inngest.createFunction(
  { name: 'Ingest stub' },
  { event: '666a/stub.created' },
  async ({ event, step }) => {
    await step.sleep(`${event.data.index * 2}s`)
    await step.run('Ingest stub', async () =>
      fetch(`http://192.168.86.195:3000/api/stubs/${event.data.id}/ingest`, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          Cookie: `session=${process.env.SESSION_SECRET}`,
          'Content-Type': 'application/json',
        },
      })
    )
  }
)
