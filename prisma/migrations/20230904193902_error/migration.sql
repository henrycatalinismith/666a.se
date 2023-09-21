-- CreateEnum
CREATE TYPE "ErrorStatus" AS ENUM ('BLOCKING', 'RESOLVED');

-- AlterTable
ALTER TABLE "Tick" ADD COLUMN     "errorId" UUID;

-- CreateTable
CREATE TABLE "Error" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "message" TEXT NOT NULL,
    "trace" TEXT NOT NULL,
    "status" "ErrorStatus" NOT NULL,

    CONSTRAINT "Error_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Tick" ADD CONSTRAINT "Tick_errorId_fkey" FOREIGN KEY ("errorId") REFERENCES "Error"("id") ON DELETE SET NULL ON UPDATE CASCADE;
