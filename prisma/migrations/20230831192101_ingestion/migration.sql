-- CreateTable
CREATE TABLE "chunk" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "scanId" UUID NOT NULL,
    "stubCount" INTEGER NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ingested" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "chunk_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "scan" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "countyId" UUID NOT NULL,
    "chunkCount" INTEGER NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "scan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stub" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "chunkId" UUID NOT NULL,
    "document_code" TEXT NOT NULL,
    "document_type" TEXT NOT NULL,
    "case_name" TEXT NOT NULL,
    "organization" TEXT NOT NULL,
    "filed" DATE NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ingested" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "stub_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "chunk_scanId_created_ingested_idx" ON "chunk"("scanId", "created" ASC, "ingested" ASC);

-- CreateIndex
CREATE INDEX "scan_countyId_created_completed_idx" ON "scan"("countyId", "created" ASC, "completed" ASC);

-- CreateIndex
CREATE INDEX "stub_created_ingested_idx" ON "stub"("created" ASC, "ingested" ASC);

-- AddForeignKey
ALTER TABLE "chunk" ADD CONSTRAINT "chunk_scanId_fkey" FOREIGN KEY ("scanId") REFERENCES "scan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "scan" ADD CONSTRAINT "scan_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "county"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stub" ADD CONSTRAINT "stub_chunkId_fkey" FOREIGN KEY ("chunkId") REFERENCES "chunk"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
