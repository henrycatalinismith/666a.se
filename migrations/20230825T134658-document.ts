import { Kysely, sql } from 'kysely'

export async function up(db: Kysely<any>): Promise<void> {
  await db.schema
    .createType('document_direction')
    .asEnum(['blank', 'incoming', 'outgoing'])
    .execute()

  await db.schema
    .createType('document_status')
    .asEnum(['ongoing', 'complete'])
    .execute()

  await db.schema
    .createTable('document')
    .addColumn('id', 'serial', (col) => col.primaryKey())
    .addColumn('case_id', 'bigint', (col) => col.notNull())
    .addColumn('company_id', 'bigint', (col) => col.notNull())
    .addColumn('county_id', 'bigint', (col) => col.notNull())
    .addColumn('municipality_id', 'bigint', (col) => col.notNull())
    .addColumn('code', 'varchar(255)', (col) => col.notNull().unique())
    .addColumn('type', 'varchar(255)', (col) => col.notNull())
    .addColumn('cfar', 'varchar(255)', (col) => col.notNull())
    .addColumn('workplace', 'varchar(255)', (col) => col.notNull())
    .addColumn('direction', sql`document_direction`, (col) => col.notNull())
    .addColumn('status', sql`document_status`, (col) => col.notNull())
    .addColumn('filed', 'date', (col) => col.notNull())
    .addColumn('created', 'timestamp', (col) =>
      col.defaultTo(sql`now()`).notNull()
    )
    .addColumn('updated', 'timestamp', (col) =>
      col.defaultTo(sql`now()`).notNull()
    )
    .execute()

  await db.schema
    .createIndex('document_company_id')
    .on('document')
    .column('company_id')
    .execute()

  await db.schema
    .createIndex('document_county_id')
    .on('document')
    .column('county_id')
    .execute()

  await db.schema
    .createIndex('document_municipality_id')
    .on('document')
    .column('municipality_id')
    .execute()

  await db.schema
    .createIndex('document_case_id')
    .on('document')
    .column('case_id')
    .execute()

  await db.schema
    .createTable('case')
    .addColumn('id', 'serial', (col) => col.primaryKey())
    .addColumn('company_id', 'bigint', (col) => col.notNull())
    .addColumn('code', 'varchar(255)', (col) => col.notNull().unique())
    .addColumn('name', 'varchar(255)', (col) => col.notNull())
    .addColumn('created', 'timestamp', (col) =>
      col.defaultTo(sql`now()`).notNull()
    )
    .addColumn('updated', 'timestamp', (col) =>
      col.defaultTo(sql`now()`).notNull()
    )
    .execute()

  await db.schema
    .createIndex('case_company_id')
    .on('case')
    .column('company_id')
    .execute()
}

export async function down(db: Kysely<any>): Promise<void> {
  await db.schema.dropType('document_direction')
  await db.schema.dropType('document_status')
  await db.schema.dropTable('document').execute()
  await db.schema.dropTable('case').execute()
}
