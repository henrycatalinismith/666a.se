-- DropForeignKey
ALTER TABLE "Tick" DROP CONSTRAINT "Tick_scanId_fkey";

-- AlterTable
ALTER TABLE "Tick" ALTER COLUMN "scanId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Tick" ADD CONSTRAINT "Tick_scanId_fkey" FOREIGN KEY ("scanId") REFERENCES "Scan"("id") ON DELETE SET NULL ON UPDATE CASCADE;
