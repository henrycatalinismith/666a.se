import { EventSchemas, Inngest } from 'inngest'

type DayCreated = {
  data: {
    id: string
    date: string
  }
}

type ScanCreated = {
  data: {
    id: string
    date: string
  }
}

type ScanCompleted = {
  data: {
    id: string
  }
}

type ChunkStarted = {
  data: {
    id: string
    date: string
    page: number
  }
}

type ChunkCompleted = {
  data: {
    id: string
  }
}

type StubCreated = {
  data: {
    id: string
    date: string
    index: number
  }
}

type Events = {
  '666a/day.created': DayCreated
  '666a/scan.created': ScanCreated
  '666a/scan.completed': ScanCompleted
  '666a/chunk.started': ChunkStarted
  '666a/chunk.completed': ChunkCompleted
  '666a/stub.created': StubCreated
}

export const inngest = new Inngest({
  name: '666a',
  schemas: new EventSchemas().fromRecord<Events>(),
})
