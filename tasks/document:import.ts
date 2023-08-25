import documents from '../data/document.json'
import { importDocument } from '../lib/document'
;(async () => {
  for (const document of documents) {
    await importDocument(document as any)
  }
})()
