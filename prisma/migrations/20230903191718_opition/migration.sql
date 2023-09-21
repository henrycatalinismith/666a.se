-- DropForeignKey
ALTER TABLE "Case" DROP CONSTRAINT "Case_companyId_fkey";

-- AlterTable
ALTER TABLE "Case" ALTER COLUMN "companyId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Case" ADD CONSTRAINT "Case_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE SET NULL ON UPDATE CASCADE;
