import clsx from 'clsx'
import _ from 'lodash'
import { cookies } from 'next/headers'

import NavBar from '../../components/NavBar'
import {
  findDocumentById,
  findDocumentsByIdWithCaseAndCompany,
} from '../../lib/document'
import { findNewNotificationsByUserId } from '../../lib/notification'
import { findUserBySessionSecret } from '../../lib/session'

export default async function Dashboard() {
  const cookieStore = cookies()
  const secret = cookieStore.get('session')?.value || ''
  const user = await findUserBySessionSecret({ secret })

  const notifications = await findNewNotificationsByUserId({
    user_id: user.id as any as number,
  })

  const documents = await Promise.all(
    notifications.map((n) => findDocumentById({ id: n.target_id }))
  )
  const documentsById = _.keyBy(documents, 'id')

  // this is shit. kysely is terrible for joins
  const newd = await findDocumentsByIdWithCaseAndCompany({
    ids: _.map(notifications, 'target_id'),
  })
  console.log(newd)

  return (
    <>
      <NavBar />
      <div className={clsx('container')}>
        dashboard
        <h2>Notifications</h2>
        <ol>
          {notifications.map((n) => (
            <li key={`${n.id}`}>{documentsById[n.target_id].code}</li>
          ))}
        </ol>
      </div>
    </>
  )
}
