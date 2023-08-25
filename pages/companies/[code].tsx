import _ from 'lodash'

import Layout from '../../app/layout'
import { lookupCasesByCompanyId } from '../../lib/case'
import { fetchAllCompanyCodes, lookupCompanyByCode } from '../../lib/company'
import { Company } from '../../lib/database'

export default function Company(props: any) {
  const { company, cases } = props
  console.log(props.company)
  console.log(props.cases)

  return (
    <>
      <Layout>
        <h1>{company.name}</h1>
        <p>{company.code}</p>

        <h2>Cases</h2>
        <table>
          <thead>
            <tr>
              <th className="text-left">Case ID</th>
              <th className="text-left">Topic</th>
            </tr>
          </thead>
          <tbody>
            {cases.map((c) => (
              <tr key={c.id}>
                <td>{c.code}</td>
                <td>{c.name}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </Layout>
    </>
  )
}

export async function getStaticPaths() {
  const codes = await fetchAllCompanyCodes()
  const paths = _.map(codes, (code) => ({ params: { code } }))
  return {
    paths,
    fallback: false,
  }
}

export async function getStaticProps(context: any) {
  console.log(context)
  const company: any = await lookupCompanyByCode({ code: context.params.code })
  let cases: any = await lookupCasesByCompanyId({ companyId: company.id })

  company.created = company.created.toISOString()
  company.updated = company.updated.toISOString()

  cases = cases.map((c) => ({
    ...c,
    created: c.created.toISOString(),
    updated: c.updated.toISOString(),
  }))

  return {
    props: {
      company,
      cases,
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
