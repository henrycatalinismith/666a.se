import { Kysely, sql } from 'kysely'

export async function up(db: Kysely<any>): Promise<void> {
  await db.schema
    .createType('notification_target_type')
    .asEnum(['document'])
    .execute()

  await db.schema.createType('notification_type').asEnum(['created']).execute()

  await db.schema
    .createTable('notification')
    .addColumn('id', 'serial', (col) => col.primaryKey())
    .addColumn('user_id', 'bigint', (col) => col.notNull())
    .addColumn('target_type', sql`notification_target_type`, (col) =>
      col.notNull()
    )
    .addColumn('target_id', 'bigint', (col) => col.notNull())
    .addColumn('type', sql`notification_type`, (col) => col.notNull())
    .addColumn('created', 'timestamp', (col) =>
      col.defaultTo(sql`now()`).notNull()
    )
    .addColumn('updated', 'timestamp', (col) =>
      col.defaultTo(sql`now()`).notNull()
    )
    .addColumn('seen', 'timestamp', (col) =>
      col.defaultTo(sql`now()`).notNull()
    )
    .execute()

  await db.schema
    .createIndex('notification_user')
    .on('notification')
    .column('user_id')
    .execute()

  await db.schema
    .createIndex('notification_uniqueness')
    .on('notification')
    .columns(['user_id', 'target_type', 'target_id', 'type'])
    .execute()
}

export async function down(db: Kysely<any>): Promise<void> {
  await db.schema.dropType('notification_target_type')
  await db.schema.dropTable('notification').execute()
}
