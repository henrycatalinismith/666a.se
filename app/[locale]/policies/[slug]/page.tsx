import fs from 'fs'
import path from 'path'

import _ from 'lodash'
import rehypeClassNames from 'rehype-class-names'
import rehypeStringify from 'rehype-stringify'
import remarkParse from 'remark-parse'
import remarkRehype from 'remark-rehype'
import { read } from 'to-vfile'
import { unified } from 'unified'

export default async function PolicyPage({ params }: any) {
  const locale = params.locale
  const filename = path.join('policies', `${params.slug}.${locale}.md`)

  const file = await unified()
    .use(remarkParse)
    .use(remarkRehype)
    // @ts-ignore
    .use(rehypeClassNames, {
      h1: 'text-2xl font-bold',
      h2: 'text-xl font-bold',
      'a[href]': 'text-blue-700 underline',
    })
    .use(rehypeStringify)
    .process(await read(filename))

  const html = String(file)

  return (
    <div
      className="container flex flex-col gap-4 py-8"
      dangerouslySetInnerHTML={{ __html: html }}
    />
  )
}

export async function generateStaticParams(): Promise<any> {
  const files = fs.readdirSync('policies')
  const params = _.chain(files)
    .map(f => f.split('/')[1])
    .map(f => f.split('.'))
    .map(([slug, locale]) => ({ slug, locale }))
    .value()
    console.log(params)
  return params
}
