/*
  Warnings:

  - The values [FAILURE] on the enum `ChunkStatus` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "ChunkStatus_new" AS ENUM ('PENDING', 'ONGOING', 'SUCCESS', 'ABORTED');
ALTER TABLE "Chunk" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "Chunk" ALTER COLUMN "status" TYPE "ChunkStatus_new" USING ("status"::text::"ChunkStatus_new");
ALTER TYPE "ChunkStatus" RENAME TO "ChunkStatus_old";
ALTER TYPE "ChunkStatus_new" RENAME TO "ChunkStatus";
DROP TYPE "ChunkStatus_old";
ALTER TABLE "Chunk" ALTER COLUMN "status" SET DEFAULT 'PENDING';
COMMIT;
