/*
  Warnings:

  - Added the required column `caseName` to the `Notification` table without a default value. This is not possible if the table is not empty.
  - Added the required column `documentCode` to the `Notification` table without a default value. This is not possible if the table is not empty.
  - Added the required column `documentDate` to the `Notification` table without a default value. This is not possible if the table is not empty.
  - Added the required column `documentType` to the `Notification` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Notification" ADD COLUMN     "caseName" TEXT NOT NULL,
ADD COLUMN     "documentCode" TEXT NOT NULL,
ADD COLUMN     "documentDate" TEXT NOT NULL,
ADD COLUMN     "documentType" TEXT NOT NULL;
