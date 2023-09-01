/*
  Warnings:

  - Added the required column `countyId` to the `stub` table without a default value. This is not possible if the table is not empty.
  - Added the required column `scanId` to the `stub` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "stub" ADD COLUMN     "countyId" UUID NOT NULL,
ADD COLUMN     "scanId" UUID NOT NULL;

-- AddForeignKey
ALTER TABLE "stub" ADD CONSTRAINT "stub_scanId_fkey" FOREIGN KEY ("scanId") REFERENCES "scan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stub" ADD CONSTRAINT "stub_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "county"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
