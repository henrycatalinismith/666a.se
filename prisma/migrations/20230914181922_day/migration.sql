/*
  Warnings:

  - You are about to drop the column `scanId` on the `Chunk` table. All the data in the column will be lost.
  - You are about to drop the column `startDate` on the `Chunk` table. All the data in the column will be lost.
  - You are about to drop the column `stubCount` on the `Chunk` table. All the data in the column will be lost.
  - You are about to drop the column `scanId` on the `Stub` table. All the data in the column will be lost.
  - You are about to drop the `Scan` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Tick` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `dayId` to the `Chunk` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Chunk" DROP CONSTRAINT "Chunk_scanId_fkey";

-- DropForeignKey
ALTER TABLE "Stub" DROP CONSTRAINT "Stub_scanId_fkey";

-- DropForeignKey
ALTER TABLE "Tick" DROP CONSTRAINT "Tick_chunkId_fkey";

-- DropForeignKey
ALTER TABLE "Tick" DROP CONSTRAINT "Tick_errorId_fkey";

-- DropForeignKey
ALTER TABLE "Tick" DROP CONSTRAINT "Tick_scanId_fkey";

-- DropForeignKey
ALTER TABLE "Tick" DROP CONSTRAINT "Tick_stubId_fkey";

-- DropIndex
DROP INDEX "Chunk_scanId_created_status_idx";

-- AlterTable
ALTER TABLE "Chunk" DROP COLUMN "scanId",
DROP COLUMN "startDate",
DROP COLUMN "stubCount",
ADD COLUMN     "dayId" UUID NOT NULL;

-- AlterTable
ALTER TABLE "Stub" DROP COLUMN "scanId";

-- DropTable
DROP TABLE "Scan";

-- DropTable
DROP TABLE "Tick";

-- DropEnum
DROP TYPE "ScanStatus";

-- DropEnum
DROP TYPE "TickType";

-- CreateTable
CREATE TABLE "Day" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date" DATE NOT NULL,

    CONSTRAINT "Day_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Day_date_key" ON "Day"("date");

-- AddForeignKey
ALTER TABLE "Chunk" ADD CONSTRAINT "Chunk_dayId_fkey" FOREIGN KEY ("dayId") REFERENCES "Day"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
