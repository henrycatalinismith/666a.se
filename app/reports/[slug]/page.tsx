import { ReportNav } from 'components/ReportNav'
import { requireUser } from 'lib/authentication'
import Totals from 'reports/Totals'
import NavBar from 'ui/NavBar'

export default async function Company({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const slug = params.slug

  return (
    <>
      <NavBar />
      <div className="flex flex-row">
        <ReportNav
          items={[
            {
              name: 'Totals',
              path: '/reports/totals',
              active: slug === 'totals',
            },
          ]}
        />
        <div>{slug === 'totals' && <Totals />}</div>
      </div>
    </>
  )
}
