import documents from '../data/document.json'
import { importDocumentFromJson } from '../lib/document'
;(async () => {
  for (const document of documents) {
    await importDocumentFromJson(document as any)
  }
})()
