-- DropForeignKey
ALTER TABLE "Chunk" DROP CONSTRAINT "Chunk_countyId_fkey";

-- AlterTable
ALTER TABLE "Chunk" ALTER COLUMN "countyId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Chunk" ADD CONSTRAINT "Chunk_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "County"("id") ON DELETE SET NULL ON UPDATE CASCADE;
