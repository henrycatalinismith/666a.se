/*
  Warnings:

  - You are about to drop the column `countyId` on the `Scan` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Scan" DROP CONSTRAINT "Scan_countyId_fkey";

-- DropIndex
DROP INDEX "Scan_countyId_created_status_idx";

-- AlterTable
ALTER TABLE "Scan" DROP COLUMN "countyId";
