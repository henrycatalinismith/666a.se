import { Settings } from 'components/Settings'
import { requireUser } from 'lib/authentication'

export default async function SettingsPage() {
  const user = await requireUser()
  return <Settings user={user} />
}
