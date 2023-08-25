import _ from 'lodash'
import Link from 'next/link'

import { fetchAllCaseCodes, lookupCaseByCode } from '../../lib/case'
import { lookupCompanyById } from '../../lib/company'
import { lookupDocumentsByCaseId } from '../../lib/document'

export default function Case(props: any) {
  const c = props.case
  const { company, documents } = props
  console.log(props.company)

  return (
    <>
      <h1>{c.code}</h1>
      <p>{c.name}</p>
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

export async function getStaticPaths() {
  const codes = await fetchAllCaseCodes()
  const paths = _.map(codes, (code) => ({ params: { code: code.split('/') } }))
  return {
    paths,
    fallback: false,
  }
}

export async function getStaticProps(context: any) {
  console.log(context)
  const code = context.params.code.join('/')
  const c: any = await lookupCaseByCode({ code })
  const company: any = await lookupCompanyById({ id: c.company_id })
  let documents: any[] = await lookupDocumentsByCaseId({ caseId: c.id })

  c.created = c.created.toISOString()
  c.updated = c.updated.toISOString()

  company.created = company.created.toISOString()
  company.updated = company.updated.toISOString()

  documents = documents.map((d) => ({
    ...d,
    created: d.created.toISOString(),
    updated: d.updated.toISOString(),
  }))

  return {
    props: {
      case: c,
      company,
      documents,
    },
  }
}

//   GetStaticProps<{
//     company: Company
//   }>
// > {
//   console.log(context)
//   const company = await lookupCompanyByCode('556613-9654')
//   return { company }
// }
