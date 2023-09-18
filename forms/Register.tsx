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

export function Register() {
  const t = useTranslations('Register')

  const formSchema = useMemo(
    () =>
      z.object({
        name: z.string().min(1, {
          message: t('nameTooShort'),
        }),
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
    const { name, email, password } = values
    const params = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, email, password }),
    }
    const response = await fetch('/api/users', params).then((response) =>
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
        className="flex flex-col gap-8 max-w-sm my-8"
      >
        <h1 className="text-2xl font-bold">{t('title')}</h1>

        <FormField
          control={form.control}
          name="name"
          render={({ field }) => (
            <FormItem>
              <FormLabel>{t('name')}</FormLabel>
              <FormControl>
                <Input placeholder="" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />

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
