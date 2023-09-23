/*
  Warnings:

  - The values [PENDING,SUCCESS,ABORTED] on the enum `NotificationEmailStatus` will be removed. If these variants are still used in the database, this will fail.
  - The values [DEVELOPER] on the enum `RoleName` will be removed. If these variants are still used in the database, this will fail.
  - The values [ACTIVE,REVOKED] on the enum `RoleStatus` will be removed. If these variants are still used in the database, this will fail.
  - The values [ACTIVE,REVOKED] on the enum `SessionStatus` will be removed. If these variants are still used in the database, this will fail.
  - Added the required column `status` to the `searches` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "SearchStatus" AS ENUM ('Pending', 'Active', 'Success', 'Error');

-- AlterEnum
BEGIN;
CREATE TYPE "NotificationEmailStatus_new" AS ENUM ('Pending', 'Success', 'Aborted');
ALTER TABLE "notifications" ALTER COLUMN "emailStatus" TYPE "NotificationEmailStatus_new" USING ("emailStatus"::text::"NotificationEmailStatus_new");
ALTER TYPE "NotificationEmailStatus" RENAME TO "NotificationEmailStatus_old";
ALTER TYPE "NotificationEmailStatus_new" RENAME TO "NotificationEmailStatus";
DROP TYPE "NotificationEmailStatus_old";
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "RoleName_new" AS ENUM ('Developer');
ALTER TABLE "roles" ALTER COLUMN "name" TYPE "RoleName_new" USING ("name"::text::"RoleName_new");
ALTER TYPE "RoleName" RENAME TO "RoleName_old";
ALTER TYPE "RoleName_new" RENAME TO "RoleName";
DROP TYPE "RoleName_old";
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "RoleStatus_new" AS ENUM ('Active', 'Revoked');
ALTER TABLE "roles" ALTER COLUMN "status" TYPE "RoleStatus_new" USING ("status"::text::"RoleStatus_new");
ALTER TYPE "RoleStatus" RENAME TO "RoleStatus_old";
ALTER TYPE "RoleStatus_new" RENAME TO "RoleStatus";
DROP TYPE "RoleStatus_old";
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "SessionStatus_new" AS ENUM ('Active', 'Revoked');
ALTER TABLE "sessions" ALTER COLUMN "status" TYPE "SessionStatus_new" USING ("status"::text::"SessionStatus_new");
ALTER TYPE "SessionStatus" RENAME TO "SessionStatus_old";
ALTER TYPE "SessionStatus_new" RENAME TO "SessionStatus";
DROP TYPE "SessionStatus_old";
COMMIT;

-- AlterTable
ALTER TABLE "searches" ADD COLUMN     "status" "SearchStatus" NOT NULL,
ALTER COLUMN "hitCount" DROP NOT NULL;
