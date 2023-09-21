/*
  Warnings:

  - You are about to drop the column `trace` on the `Error` table. All the data in the column will be lost.
  - Added the required column `stack` to the `Error` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Error" DROP COLUMN "trace",
ADD COLUMN     "stack" TEXT NOT NULL;
