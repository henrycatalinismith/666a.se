import NavBar from '../../../components/NavBar'
import { ReportNav } from '../../../components/ReportNav'
import { requireUser } from '../../../lib/authentication'
import Ticks from '../../../reports/Ticks'
import Totals from '../../../reports/Totals'

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
              name: 'Ticks',
              path: '/reports/ticks',
              active: slug === 'ticks',
            },
            {
              name: 'Totals',
              path: '/reports/totals',
              active: slug === 'totals',
            },
          ]}
        />
        <div>
          {slug === 'ticks' && <Ticks />}
          {slug === 'totals' && <Totals />}
        </div>
      </div>
    </>
  )
}
