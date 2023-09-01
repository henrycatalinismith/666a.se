/*
  Warnings:

  - You are about to drop the column `rowNumber` on the `stub` table. All the data in the column will be lost.
  - Added the required column `index` to the `stub` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "stub" DROP COLUMN "rowNumber",
ADD COLUMN     "index" INTEGER NOT NULL;
