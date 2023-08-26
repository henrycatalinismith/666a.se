'use client'

import { FormEvent, useCallback, useState } from 'react'

export default function LoginForm() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const onSubmit = useCallback(
    async (event: FormEvent) => {
      event.preventDefault()
      const params = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      }
      const response = await fetch('/api/login', params).then((response) =>
        response.json()
      )
      if (response.status === 'success') {
        navigation.navigate('/companies/556737-0431')
      }
      console.log(response)
    },
    [email, password]
  )

  return (
    <form className="space-y-4 md:space-y-6" onSubmit={onSubmit}>
      <p>
        <label
          className="lock mb-2 text-sm font-medium text-gray-900 dark:text-white"
          htmlFor="email"
        >
          Email
        </label>
        <input
          className="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
          id="email"
          type="text"
          name="email"
          onChange={(e) => setEmail(e?.target.value)}
        />
      </p>

      <p>
        <label
          className="lock mb-2 text-sm font-medium text-gray-900 dark:text-white"
          htmlFor="password"
        >
          Password
        </label>
        <input
          className="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
          id="password"
          type="password"
          name="password"
          onChange={(e) => setPassword(e?.target.value)}
        />
      </p>

      <button
        type="submit"
        className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
      >
        Sign in
      </button>
    </form>
  )
}
