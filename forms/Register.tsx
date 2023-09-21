'use client'

import { zodResolver } from '@hookform/resolvers/zod'
import { useRouter } from 'next/navigation'
import { useTranslations } from 'next-intl'
import { FC, useMemo } from 'react'
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

const Row: FC<{ children: any }> = ({ children }) => (
  <div className="flex flex-col gap-2 md:flex-row md:gap-10">{children}</div>
)

const Desc: FC<{ children: string; id: string }> = ({ children, id }) => (
  <p id={id} className="flex-1 text-indigo-700 text-sm self-end md:max-w-md">
    {children}
  </p>
)

export function Register() {
  const t = useTranslations('Register')

  const formSchema = useMemo(
    () =>
      z.object({
        name: z.string().min(1, {
          message: t('nameTooShort'),
        }),
        companyCode: z.string().regex(/^\d{6}-\d{4}/, {
          message: t('companyCodeInvalid'),
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
    const { name, companyCode, email, password } = values
    const params = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, companyCode, email, password }),
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
        className="flex flex-col gap-8 my-8"
      >
        <h1 className="text-2xl font-bold">{t('title')}</h1>

        <Row>
          <FormField
            control={form.control}
            name="name"
            render={({ field }) => (
              <FormItem className="flex-1 max-w-sm">
                <FormLabel>{t('name')}</FormLabel>
                <FormControl>
                  <Input
                    aria-describedby="#name-desc"
                    placeholder=""
                    {...field}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <Desc id="name-desc">{t('nameDescription')}</Desc>
        </Row>

        <Row>
          <FormField
            control={form.control}
            name="companyCode"
            render={({ field }) => (
              <FormItem className="flex-1 max-w-sm">
                <FormLabel>{t('companyCode')}</FormLabel>
                <FormControl>
                  <Input
                    aria-describedby="#companyCode-desc"
                    type="text"
                    placeholder=""
                    {...field}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <Desc id="companyCode-desc">{t('companyCodeDescription')}</Desc>
        </Row>

        <Row>
          <FormField
            control={form.control}
            name="email"
            render={({ field }) => (
              <FormItem className="flex-1 max-w-sm">
                <FormLabel>{t('email')}</FormLabel>
                <FormControl>
                  <Input
                    aria-describedby="#email-desc"
                    type="email"
                    placeholder=""
                    {...field}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <Desc id="email-desc">{t('emailDescription')}</Desc>
        </Row>

        <Row>
          <FormField
            control={form.control}
            name="password"
            render={({ field }) => (
              <FormItem className="flex-1 max-w-sm">
                <FormLabel>{t('password')}</FormLabel>
                <FormControl>
                  <Input
                    aria-describedby="#email-desc"
                    type="password"
                    placeholder=""
                    {...field}
                  />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <Desc id="password-desc">{t('passwordDescription')}</Desc>
        </Row>

        <Button type="submit" className="w-max">
          {t('submit')}
        </Button>
      </form>
    </Form>
  )
}
