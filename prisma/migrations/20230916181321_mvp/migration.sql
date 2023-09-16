/*
  Warnings:

  - You are about to drop the `Case` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Chunk` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Company` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `County` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Day` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Document` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Error` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Municipality` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Scan` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Stub` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Type` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Workplace` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "NotificationEmailStatus" AS ENUM ('PENDING', 'SUCCESS', 'ABORTED');

-- DropForeignKey
ALTER TABLE "Case" DROP CONSTRAINT "Case_companyId_fkey";

-- DropForeignKey
ALTER TABLE "Chunk" DROP CONSTRAINT "Chunk_scanId_fkey";

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_caseId_fkey";

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_companyId_fkey";

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_countyId_fkey";

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_municipalityId_fkey";

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_typeId_fkey";

-- DropForeignKey
ALTER TABLE "Document" DROP CONSTRAINT "Document_workplaceId_fkey";

-- DropForeignKey
ALTER TABLE "Municipality" DROP CONSTRAINT "Municipality_countyId_fkey";

-- DropForeignKey
ALTER TABLE "Scan" DROP CONSTRAINT "Scan_dayId_fkey";

-- DropForeignKey
ALTER TABLE "Stub" DROP CONSTRAINT "Stub_chunkId_fkey";

-- DropForeignKey
ALTER TABLE "Stub" DROP CONSTRAINT "Stub_documentId_fkey";

-- DropTable
DROP TABLE "Case";

-- DropTable
DROP TABLE "Chunk";

-- DropTable
DROP TABLE "Company";

-- DropTable
DROP TABLE "County";

-- DropTable
DROP TABLE "Day";

-- DropTable
DROP TABLE "Document";

-- DropTable
DROP TABLE "Error";

-- DropTable
DROP TABLE "Municipality";

-- DropTable
DROP TABLE "Scan";

-- DropTable
DROP TABLE "Stub";

-- DropTable
DROP TABLE "Type";

-- DropTable
DROP TABLE "Workplace";

-- DropEnum
DROP TYPE "CaseStatus";

-- DropEnum
DROP TYPE "ChunkStatus";

-- DropEnum
DROP TYPE "ErrorStatus";

-- DropEnum
DROP TYPE "ScanStatus";

-- DropEnum
DROP TYPE "StubStatus";

-- CreateTable
CREATE TABLE "Notification" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "subscriptionId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "companyCode" TEXT NOT NULL,
    "emailStatus" "NotificationEmailStatus" NOT NULL,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Subscription" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" UUID NOT NULL,
    "companyCode" TEXT NOT NULL,

    CONSTRAINT "Subscription_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES "Subscription"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Subscription" ADD CONSTRAINT "Subscription_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
