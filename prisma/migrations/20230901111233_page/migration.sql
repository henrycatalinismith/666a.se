/*
  Warnings:

  - You are about to drop the column `pageNumber` on the `chunk` table. All the data in the column will be lost.
  - Added the required column `page` to the `chunk` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "chunk" DROP COLUMN "pageNumber",
ADD COLUMN     "page" INTEGER NOT NULL;
