/*
  Warnings:

  - You are about to drop the column `countyId` on the `Stub` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Stub" DROP CONSTRAINT "Stub_countyId_fkey";

-- AlterTable
ALTER TABLE "Stub" DROP COLUMN "countyId";
