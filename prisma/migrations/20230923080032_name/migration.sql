/*
  Warnings:

  - You are about to drop the column `diariumSearchId` on the `refreshes` table. All the data in the column will be lost.
  - You are about to drop the `diarium_parameters` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `diarium_results` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `diarium_searches` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `searchId` to the `refreshes` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "SearchParameterName" AS ENUM ('FromDate', 'OnlyActive', 'OrganisationNumber', 'SelectedCounty', 'ShowToolbar', 'ToDate', 'id', 'page', 'sortDirection', 'sortOrder');

-- DropForeignKey
ALTER TABLE "diarium_parameters" DROP CONSTRAINT "diarium_parameters_diariumSearchId_fkey";

-- DropForeignKey
ALTER TABLE "diarium_results" DROP CONSTRAINT "diarium_results_diariumSearchId_fkey";

-- DropForeignKey
ALTER TABLE "refreshes" DROP CONSTRAINT "refreshes_diariumSearchId_fkey";

-- AlterTable
ALTER TABLE "refreshes" DROP COLUMN "diariumSearchId",
ADD COLUMN     "searchId" UUID NOT NULL;

-- DropTable
DROP TABLE "diarium_parameters";

-- DropTable
DROP TABLE "diarium_results";

-- DropTable
DROP TABLE "diarium_searches";

-- DropEnum
DROP TYPE "DiariumParameterName";

-- CreateTable
CREATE TABLE "searches" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "hitCount" TEXT NOT NULL,

    CONSTRAINT "searches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "search_parameters" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "searchId" UUID NOT NULL,
    "name" "SearchParameterName" NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "search_parameters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "search_results" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "searchId" UUID NOT NULL,
    "caseName" TEXT NOT NULL,
    "companyName" TEXT NOT NULL,
    "documentCode" TEXT NOT NULL,
    "documentDate" TEXT NOT NULL,
    "documentType" TEXT NOT NULL,

    CONSTRAINT "search_results_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "search_parameters" ADD CONSTRAINT "search_parameters_searchId_fkey" FOREIGN KEY ("searchId") REFERENCES "searches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "search_results" ADD CONSTRAINT "search_results_searchId_fkey" FOREIGN KEY ("searchId") REFERENCES "searches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refreshes" ADD CONSTRAINT "refreshes_searchId_fkey" FOREIGN KEY ("searchId") REFERENCES "searches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
