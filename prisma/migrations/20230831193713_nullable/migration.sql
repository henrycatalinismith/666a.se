-- AlterTable
ALTER TABLE "chunk" ALTER COLUMN "ingested" DROP NOT NULL;

-- AlterTable
ALTER TABLE "scan" ALTER COLUMN "completed" DROP NOT NULL;

-- AlterTable
ALTER TABLE "stub" ALTER COLUMN "ingested" DROP NOT NULL;
