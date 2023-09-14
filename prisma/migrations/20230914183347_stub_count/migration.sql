/*
  Warnings:

  - You are about to drop the column `chunkCount` on the `Chunk` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Chunk" DROP COLUMN "chunkCount",
ADD COLUMN     "stubCount" INTEGER;
