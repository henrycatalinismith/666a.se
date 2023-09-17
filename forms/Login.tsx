'use client'

import { zodResolver } from '@hookform/resolvers/zod'
import { useRouter } from 'next/navigation'
import { useTranslations } from 'next-intl'
import { useForm } from 'react-hook-form'
import { Button } from 'ui/Button'
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from 'ui/Form'
import { Input } from 'ui/Input'
import * as z from 'zod'

const formSchema = z.object({
  email: z.string().min(2, {
    message: 'Email too short',
  }),
  password: z.string().min(2, {
    message: 'Password too short',
  }),
})

export function Login() {
  const t = useTranslations('Login')

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      email: '',
      password: '',
    },
  })
  const router = useRouter()
  const onSubmit = async (values: z.infer<typeof formSchema>) => {
    const { email, password } = values
    const params = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password }),
    }
    const response = await fetch('/login', params).then((response) =>
      response.json()
    )
    if (response.status === 'success') {
      router.push(response.destination)
    }
  }

  const onError = async (e: any) => {
    console.log(e)
  }

  return (
    <Form {...form}>
      <form
        onSubmit={form.handleSubmit(onSubmit, onError)}
        className="space-y-8"
      >
        <h2>{t('title')}</h2>
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input placeholder="" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <FormField
          control={form.control}
          name="password"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Password</FormLabel>
              <FormControl>
                <Input type="password" placeholder="" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button type="submit">Submit</Button>
      </form>
    </Form>
  )
}
