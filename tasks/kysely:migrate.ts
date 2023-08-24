require('dotenv').config()

import { promises as fs } from 'fs'
import * as path from 'path'

import { Migrator, FileMigrationProvider } from 'kysely'
import { run } from 'kysely-migration-cli'

import { db } from '../lib/database'

console.log(process.env.PLANETSCALE_DEV_HOST)
console.log(process.env.PLANETSCALE_DEV_USERNAME)
console.log(process.env.PLANETSCALE_DEV_PASSWORD)
;(async () => {
  const migrator = new Migrator({
    db,
    provider: new FileMigrationProvider({
      fs,
      path,
      migrationFolder: path.join(__dirname, '../migrations'),
    }),
  })

  run(db, migrator, path.resolve(`${__dirname}/../migrations`))
})()
