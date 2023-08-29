import clsx from 'clsx'

import NavBar from '../../components/NavBar'
import { requireUser } from '../../lib/authentication'
import prisma from '../../lib/database'

export default async function Dashboard() {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  // const notifications = await findNewNotificationsByUserId({
  //   user_id: session!.user.id as any as number,
  // })

  // const documents = await Promise.all(
  // notifications.map((n) => findDocumentById({ id: n.target_id }))
  // )
  // const documentsById = _.keyBy(documents, 'id')

  // this is shit. kysely is terrible for joins
  // const newd = await findDocumentsByIdWithCaseAndCompany({
  // ids: _.map(notifications, 'target_id'),
  // })
  // console.log(newd)

  return (
    <>
      <NavBar />
      <div className="container">
        dashboard
        <h2>Notifications for {user.name}</h2>
        <ol></ol>
        <h2>Subscriptions</h2>
        <ol></ol>
      </div>
    </>
  )
}
