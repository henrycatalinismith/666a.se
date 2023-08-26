import { cookies } from 'next/headers'

import LoginForm from '../components/LoginForm'

export default function Home() {
  const cookieStore = cookies()

  return (
    <div className="h-screen bg-snow w-full flex justify-center items-center">
      <p>{JSON.stringify(cookieStore.get('session'))}</p>
      <LoginForm />
    </div>
  )
}
