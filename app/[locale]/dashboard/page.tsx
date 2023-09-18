import { Dashboard } from 'components/Dashboard'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'

export default async function DashboardPage() {
  const user = await requireUser()
  const subscriptions = await prisma.subscription.findMany({
    where: { userId: user.id },
  })
  return <Dashboard subscription={subscriptions[0]} />
}
