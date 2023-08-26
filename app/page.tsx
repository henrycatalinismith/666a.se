import LoginForm from '../components/LoginForm'

export default function Home() {
  // <main className="flex min-h-screen flex-col items-center justify-between p-24"></main>
  return (
    <div className="h-screen bg-snow w-full flex justify-center items-center">
      <LoginForm />
    </div>
  )
}
