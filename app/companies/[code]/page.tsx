import Link from 'next/link'

import { lookupCasesByCompanyId } from '../../../lib/case'
import { lookupCompanyByCode } from '../../../lib/company'
import { Company } from '../../../lib/database'

export default async function Company({ params }: any) {
  const company = await lookupCompanyByCode({ code: params.code })
  const cases = await lookupCasesByCompanyId({
    companyId: company.id as any as number,
  })

  return (
    <>
      <h1>{company.name}</h1>
      <p>{company.code}</p>

      <h2>Case History</h2>
      <table>
        <thead>
          <tr>
            <th className="text-left">Case ID</th>
            <th className="text-left">Topic</th>
          </tr>
        </thead>
        <tbody>
          {cases.map((c: any) => (
            <tr key={c.id}>
              <td>
                <Link href={`/cases/${c.code}`}>{c.code}</Link>
              </td>
              <td>{c.name}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </>
  )
}
