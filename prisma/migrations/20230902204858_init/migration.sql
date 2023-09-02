-- CreateEnum
CREATE TYPE "SubscribableType" AS ENUM ('Company');

-- CreateEnum
CREATE TYPE "Tickable" AS ENUM ('chunk', 'scan', 'stub');

-- CreateTable
CREATE TABLE "case" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "companyId" UUID NOT NULL,
    "statusId" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "case_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chunk" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "countyId" UUID NOT NULL,
    "scanId" UUID NOT NULL,
    "startDate" DATE,
    "page" INTEGER NOT NULL,
    "stubCount" INTEGER,
    "hitCount" TEXT,
    "ingested" TIMESTAMP(3),

    CONSTRAINT "chunk_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "company" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,

    CONSTRAINT "company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "county" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ticked" TIMESTAMP(3),
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,

    CONSTRAINT "county_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "document" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "caseId" UUID NOT NULL,
    "companyId" UUID NOT NULL,
    "countyId" UUID NOT NULL,
    "municipalityId" UUID NOT NULL,
    "typeId" UUID NOT NULL,
    "workplaceId" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "direction" TEXT NOT NULL,
    "typeText" TEXT NOT NULL,

    CONSTRAINT "document_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "municipality" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "countyId" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,

    CONSTRAINT "municipality_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "scan" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "countyId" UUID NOT NULL,
    "startDate" DATE,
    "chunkCount" INTEGER NOT NULL,
    "completed" TIMESTAMP(3),

    CONSTRAINT "scan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" UUID NOT NULL,
    "secret" TEXT NOT NULL,

    CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "status" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,

    CONSTRAINT "status_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stub" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ingested" TIMESTAMP(3),
    "chunkId" UUID NOT NULL,
    "countyId" UUID NOT NULL,
    "scanId" UUID NOT NULL,
    "index" INTEGER NOT NULL,
    "caseName" TEXT NOT NULL,
    "companyName" TEXT NOT NULL,
    "documentCode" TEXT NOT NULL,
    "documentType" TEXT NOT NULL,
    "documentDate" DATE NOT NULL,

    CONSTRAINT "stub_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscription" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" UUID NOT NULL,
    "targetType" "SubscribableType" NOT NULL,
    "targetId" UUID NOT NULL,

    CONSTRAINT "subscription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tick" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "targetType" "Tickable" NOT NULL,
    "targetId" UUID NOT NULL,

    CONSTRAINT "tick_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "type" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,

    CONSTRAINT "type_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workplace" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,

    CONSTRAINT "workplace_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "case_code_key" ON "case"("code");

-- CreateIndex
CREATE INDEX "chunk_scanId_created_ingested_idx" ON "chunk"("scanId", "created" ASC, "ingested" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "company_code_key" ON "company"("code");

-- CreateIndex
CREATE UNIQUE INDEX "company_slug_key" ON "company"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "county_code_key" ON "county"("code");

-- CreateIndex
CREATE UNIQUE INDEX "county_slug_key" ON "county"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "document_code_key" ON "document"("code");

-- CreateIndex
CREATE UNIQUE INDEX "municipality_code_key" ON "municipality"("code");

-- CreateIndex
CREATE UNIQUE INDEX "municipality_slug_key" ON "municipality"("slug");

-- CreateIndex
CREATE INDEX "scan_countyId_created_completed_idx" ON "scan"("countyId", "created" ASC, "completed" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "status_slug_key" ON "status"("slug");

-- CreateIndex
CREATE INDEX "stub_created_ingested_idx" ON "stub"("created" ASC, "ingested" ASC);

-- CreateIndex
CREATE UNIQUE INDEX "type_slug_key" ON "type"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "workplace_code_key" ON "workplace"("code");

-- AddForeignKey
ALTER TABLE "case" ADD CONSTRAINT "case_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "case" ADD CONSTRAINT "case_statusId_fkey" FOREIGN KEY ("statusId") REFERENCES "status"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chunk" ADD CONSTRAINT "chunk_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "county"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chunk" ADD CONSTRAINT "chunk_scanId_fkey" FOREIGN KEY ("scanId") REFERENCES "scan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "document" ADD CONSTRAINT "document_caseId_fkey" FOREIGN KEY ("caseId") REFERENCES "case"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "document" ADD CONSTRAINT "document_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "document" ADD CONSTRAINT "document_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "county"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "document" ADD CONSTRAINT "document_municipalityId_fkey" FOREIGN KEY ("municipalityId") REFERENCES "municipality"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "document" ADD CONSTRAINT "document_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES "type"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "document" ADD CONSTRAINT "document_workplaceId_fkey" FOREIGN KEY ("workplaceId") REFERENCES "workplace"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "municipality" ADD CONSTRAINT "municipality_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "county"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "scan" ADD CONSTRAINT "scan_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "county"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stub" ADD CONSTRAINT "stub_chunkId_fkey" FOREIGN KEY ("chunkId") REFERENCES "chunk"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stub" ADD CONSTRAINT "stub_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "county"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stub" ADD CONSTRAINT "stub_scanId_fkey" FOREIGN KEY ("scanId") REFERENCES "scan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription" ADD CONSTRAINT "company_subscribableId" FOREIGN KEY ("targetId") REFERENCES "company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription" ADD CONSTRAINT "subscription_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
