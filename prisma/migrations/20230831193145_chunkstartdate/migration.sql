/*
  Warnings:

  - Added the required column `startDate` to the `chunk` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "chunk" ADD COLUMN     "startDate" DATE NOT NULL;
