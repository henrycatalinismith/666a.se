/*
  Warnings:

  - The values [FAILURE] on the enum `StubStatus` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "StubStatus_new" AS ENUM ('PENDING', 'SUCCESS', 'ABORTED');
ALTER TABLE "Stub" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "Stub" ALTER COLUMN "status" TYPE "StubStatus_new" USING ("status"::text::"StubStatus_new");
ALTER TYPE "StubStatus" RENAME TO "StubStatus_old";
ALTER TYPE "StubStatus_new" RENAME TO "StubStatus";
DROP TYPE "StubStatus_old";
ALTER TABLE "Stub" ALTER COLUMN "status" SET DEFAULT 'PENDING';
COMMIT;
