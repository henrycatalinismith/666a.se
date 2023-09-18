import { SettingsName } from 'components/SettingsName'
import { requireUser } from 'lib/authentication'

export default async function SettingsNamePage() {
  const user = await requireUser()
  return <SettingsName user={user} />
}
