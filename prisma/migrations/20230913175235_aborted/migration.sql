/*
  Warnings:

  - The values [FAILURE] on the enum `ScanStatus` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "ScanStatus_new" AS ENUM ('PENDING', 'ONGOING', 'SUCCESS', 'ABORTED');
ALTER TABLE "Scan" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "Scan" ALTER COLUMN "status" TYPE "ScanStatus_new" USING ("status"::text::"ScanStatus_new");
ALTER TYPE "ScanStatus" RENAME TO "ScanStatus_old";
ALTER TYPE "ScanStatus_new" RENAME TO "ScanStatus";
DROP TYPE "ScanStatus_old";
ALTER TABLE "Scan" ALTER COLUMN "status" SET DEFAULT 'PENDING';
COMMIT;
