/*
  Warnings:

  - Added the required column `countyId` to the `chunk` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "chunk" ADD COLUMN     "countyId" UUID NOT NULL;

-- AddForeignKey
ALTER TABLE "chunk" ADD CONSTRAINT "chunk_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "county"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
