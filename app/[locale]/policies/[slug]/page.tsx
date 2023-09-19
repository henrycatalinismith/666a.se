import path from 'path'

import glob from 'glob'
import _ from 'lodash'
import { useLocale } from 'next-intl'
import rehypeClassNames from 'rehype-class-names'
import rehypeStringify from 'rehype-stringify'
import remarkParse from 'remark-parse'
import remarkRehype from 'remark-rehype'
import { read } from 'to-vfile'
import { unified } from 'unified'

export default async function PolicyPage({ params }: any) {
  const locale = useLocale()
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
  const files = glob.sync(`policies/*.md`)
  const slugs = _.uniq(_.map(files, (f) => f.split('.')[0]))
  return slugs.map((slug) => ({ slug }))
}
