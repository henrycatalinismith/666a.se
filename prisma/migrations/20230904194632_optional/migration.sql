/*
  Warnings:

  - You are about to drop the column `cause` on the `Error` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Error" DROP COLUMN "cause",
ALTER COLUMN "stack" DROP NOT NULL,
ALTER COLUMN "code" DROP NOT NULL;
