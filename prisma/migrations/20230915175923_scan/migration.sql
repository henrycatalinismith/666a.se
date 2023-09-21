/*
  Warnings:

  - You are about to drop the column `dayId` on the `Chunk` table. All the data in the column will be lost.
  - Added the required column `scanId` to the `Chunk` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "ScanStatus" AS ENUM ('PENDING', 'ONGOING', 'SUCCESS', 'ABORTED');

-- DropForeignKey
ALTER TABLE "Chunk" DROP CONSTRAINT "Chunk_dayId_fkey";

-- AlterTable
ALTER TABLE "Chunk" DROP COLUMN "dayId",
ADD COLUMN     "scanId" UUID NOT NULL;

-- CreateTable
CREATE TABLE "Scan" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "dayId" UUID NOT NULL,
    "status" "ScanStatus" NOT NULL,

    CONSTRAINT "Scan_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Chunk" ADD CONSTRAINT "Chunk_scanId_fkey" FOREIGN KEY ("scanId") REFERENCES "Scan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scan" ADD CONSTRAINT "Scan_dayId_fkey" FOREIGN KEY ("dayId") REFERENCES "Day"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
