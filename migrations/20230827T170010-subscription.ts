import { Kysely, sql } from 'kysely'

export async function up(db: Kysely<any>): Promise<void> {
  await db.schema
    .createTable('subscription')
    .addColumn('id', 'serial', (col) => col.primaryKey())
    .addColumn('user_id', 'bigint', (col) => col.notNull())
    .addColumn('target_type', 'varchar(255)', (col) => col.notNull())
    .addColumn('target_id', 'bigint', (col) => col.notNull())
    .addColumn('created', 'timestamp', (col) =>
      col.defaultTo(sql`now()`).notNull()
    )
    .addColumn('updated', 'timestamp', (col) =>
      col.defaultTo(sql`now()`).notNull()
    )
    .execute()

  await db.schema
    .createIndex('subscription_user')
    .on('subscription')
    .column('user_id')
    .execute()

  await db.schema
    .createIndex('subscription_target')
    .on('subscription')
    .columns(['target_type', 'target_id'])
    .execute()
}

export async function down(db: Kysely<any>): Promise<void> {
  await db.schema.dropTable('subscription').execute()
}
