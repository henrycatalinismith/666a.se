-- DropForeignKey
ALTER TABLE "Scan" DROP CONSTRAINT "Scan_countyId_fkey";

-- AlterTable
ALTER TABLE "Scan" ADD COLUMN     "date" DATE,
ALTER COLUMN "countyId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Scan" ADD CONSTRAINT "Scan_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "County"("id") ON DELETE SET NULL ON UPDATE CASCADE;
