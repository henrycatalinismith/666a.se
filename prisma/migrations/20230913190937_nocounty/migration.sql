/*
  Warnings:

  - You are about to drop the column `countyId` on the `Chunk` table. All the data in the column will be lost.
  - You are about to drop the column `ticked` on the `County` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Chunk" DROP CONSTRAINT "Chunk_countyId_fkey";

-- AlterTable
ALTER TABLE "Chunk" DROP COLUMN "countyId";

-- AlterTable
ALTER TABLE "County" DROP COLUMN "ticked";
