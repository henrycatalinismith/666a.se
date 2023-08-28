import { Kysely, sql } from 'kysely'

export async function up(db: Kysely<any>): Promise<void> {
  await db.schema
    .createTable('session')
    .addColumn('id', 'serial', (col) => col.primaryKey())
    .addColumn('user_id', 'bigint', (col) => col.unique().notNull())
    .addColumn('secret', 'varchar(255)', (col) => col.unique().notNull())
    .addColumn('created', 'timestamp', (col) =>
      col.defaultTo(sql`now()`).notNull()
    )
    .addColumn('updated', 'timestamp', (col) =>
      col.defaultTo(sql`now()`).notNull()
    )
    .execute()

  await db.schema
    .createIndex('session_user')
    .on('session')
    .column('user_id')
    .execute()

  await db.schema
    .createIndex('session_secret')
    .on('session')
    .column('secret')
    .execute()
}

export async function down(db: Kysely<any>): Promise<void> {
  await db.schema.dropTable('session').execute()
}
