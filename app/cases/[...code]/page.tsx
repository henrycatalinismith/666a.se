import _ from 'lodash'
import Link from 'next/link'

import { lookupCaseByCode } from '../../../lib/case'
import { lookupCompanyById } from '../../../lib/company'
import { lookupDocumentsByCaseId } from '../../../lib/document'

export default async function Case({ params }: any) {
  const c = await lookupCaseByCode({ code: params.code.join('/') })
  const company = await lookupCompanyById({ id: c!.company_id })
  const documents = await lookupDocumentsByCaseId({
    caseId: c!.id as any as number,
  })

  return (
    <>
      <h1>{c!.code}</h1>
      <p>{c!.name}</p>
      <p>
        <Link href={`/companies/${company.code}`}>{company.name}</Link>
      </p>

      <h2>Filing History</h2>
      <table>
        <thead>
          <tr>
            <th className="text-left">Date</th>
            <th className="text-left">Type</th>
            <th className="text-left">Filing ID</th>
          </tr>
        </thead>
        <tbody>
          {documents.map((document: any) => (
            <tr key={document.id}>
              <td>{document.filed}</td>
              <td>{document.type}</td>
              <td>{document.code}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </>
  )
}
