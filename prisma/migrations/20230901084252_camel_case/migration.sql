/*
  Warnings:

  - You are about to drop the column `case_name` on the `stub` table. All the data in the column will be lost.
  - You are about to drop the column `document_code` on the `stub` table. All the data in the column will be lost.
  - You are about to drop the column `document_type` on the `stub` table. All the data in the column will be lost.
  - Added the required column `caseName` to the `stub` table without a default value. This is not possible if the table is not empty.
  - Added the required column `documentCode` to the `stub` table without a default value. This is not possible if the table is not empty.
  - Added the required column `documentType` to the `stub` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "stub" DROP COLUMN "case_name",
DROP COLUMN "document_code",
DROP COLUMN "document_type",
ADD COLUMN     "caseName" TEXT NOT NULL,
ADD COLUMN     "documentCode" TEXT NOT NULL,
ADD COLUMN     "documentType" TEXT NOT NULL;
