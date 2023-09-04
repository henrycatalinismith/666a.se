/*
  Warnings:

  - Added the required column `cause` to the `Error` table without a default value. This is not possible if the table is not empty.
  - Added the required column `code` to the `Error` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Error" ADD COLUMN     "cause" TEXT NOT NULL,
ADD COLUMN     "code" TEXT NOT NULL;
