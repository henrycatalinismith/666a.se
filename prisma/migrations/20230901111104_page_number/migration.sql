/*
  Warnings:

  - You are about to drop the column `index` on the `chunk` table. All the data in the column will be lost.
  - Added the required column `pageNumber` to the `chunk` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "chunk" DROP COLUMN "index",
ADD COLUMN     "pageNumber" INTEGER NOT NULL;
