/*
  Warnings:

  - You are about to drop the column `updateId` on the `Notification` table. All the data in the column will be lost.
  - You are about to drop the `Update` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `refreshId` to the `Notification` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Notification" DROP CONSTRAINT "Notification_updateId_fkey";

-- DropForeignKey
ALTER TABLE "Update" DROP CONSTRAINT "Update_subscriptionId_fkey";

-- AlterTable
ALTER TABLE "Notification" DROP COLUMN "updateId",
ADD COLUMN     "refreshId" UUID NOT NULL;

-- DropTable
DROP TABLE "Update";

-- CreateTable
CREATE TABLE "Refresh" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "subscriptionId" UUID NOT NULL,

    CONSTRAINT "Refresh_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_refreshId_fkey" FOREIGN KEY ("refreshId") REFERENCES "Refresh"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Refresh" ADD CONSTRAINT "Refresh_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES "Subscription"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
