/*
  Warnings:

  - You are about to drop the column `caseName` on the `notifications` table. All the data in the column will be lost.
  - You are about to drop the column `companyCode` on the `notifications` table. All the data in the column will be lost.
  - You are about to drop the column `documentCode` on the `notifications` table. All the data in the column will be lost.
  - You are about to drop the column `documentDate` on the `notifications` table. All the data in the column will be lost.
  - You are about to drop the column `documentType` on the `notifications` table. All the data in the column will be lost.
  - Added the required column `searchResultId` to the `notifications` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "notifications" DROP COLUMN "caseName",
DROP COLUMN "companyCode",
DROP COLUMN "documentCode",
DROP COLUMN "documentDate",
DROP COLUMN "documentType",
ADD COLUMN     "searchResultId" UUID NOT NULL;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_searchResultId_fkey" FOREIGN KEY ("searchResultId") REFERENCES "search_results"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
