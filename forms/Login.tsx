'use client'

import { zodResolver } from '@hookform/resolvers/zod'
import { useRouter } from 'next/navigation'
import { useTranslations } from 'next-intl'
import { useMemo } from 'react'
import { useForm } from 'react-hook-form'
import * as z from 'zod'

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

export function Login() {
  const t = useTranslations('Login')

  const formSchema = useMemo(
    () =>
      z.object({
        email: z.string().min(2, {
          message: t('emailTooShort'),
        }),
        password: z.string().min(2, {
          message: t('passwordTooShort'),
        }),
      }),
    [t]
  )

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
    const response = await fetch('/api/login', params).then((response) =>
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
        className="flex flex-col gap-8"
      >
        <h2>{t('title')}</h2>
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>{t('email')}</FormLabel>
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
              <FormLabel>{t('password')}</FormLabel>
              <FormControl>
                <Input type="password" placeholder="" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button type="submit">{t('submit')}</Button>
      </form>
    </Form>
  )
}
