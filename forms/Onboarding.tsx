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

export function Onboarding() {
  const t = useTranslations('Onboarding')

  const formSchema = useMemo(
    () =>
      z.object({
        companyCode: z.string().regex(/^\d{6}-\d{4}/, {
          message: t('invalidCode'),
        }),
      }),
    [t]
  )

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      companyCode: '',
    },
  })

  const router = useRouter()
  const onSubmit = async (values: z.infer<typeof formSchema>) => {
    const { companyCode } = values
    const params = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ companyCode }),
    }
    const response = await fetch('/api/me/subscribe', params).then((response) =>
      response.json()
    )
    if (response.status === 'success') {
      router.push('/dashboard')
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
        <FormField
          control={form.control}
          name="companyCode"
          render={({ field }) => (
            <FormItem>
              <FormLabel>{t('inputLabel')}</FormLabel>
              <FormControl>
                <Input placeholder="" {...field} />
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
