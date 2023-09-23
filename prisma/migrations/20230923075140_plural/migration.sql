/*
  Warnings:

  - You are about to drop the `diarium_parameter` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `diarium_result` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `diarium_search` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `notification` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `refresh` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `role` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `session` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `subscription` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "diarium_parameter" DROP CONSTRAINT "diarium_parameter_diariumSearchId_fkey";

-- DropForeignKey
ALTER TABLE "diarium_result" DROP CONSTRAINT "diarium_result_diariumSearchId_fkey";

-- DropForeignKey
ALTER TABLE "notification" DROP CONSTRAINT "notification_refreshId_fkey";

-- DropForeignKey
ALTER TABLE "notification" DROP CONSTRAINT "notification_subscriptionId_fkey";

-- DropForeignKey
ALTER TABLE "notification" DROP CONSTRAINT "notification_userId_fkey";

-- DropForeignKey
ALTER TABLE "refresh" DROP CONSTRAINT "refresh_diariumSearchId_fkey";

-- DropForeignKey
ALTER TABLE "refresh" DROP CONSTRAINT "refresh_subscriptionId_fkey";

-- DropForeignKey
ALTER TABLE "role" DROP CONSTRAINT "role_userId_fkey";

-- DropForeignKey
ALTER TABLE "session" DROP CONSTRAINT "session_userId_fkey";

-- DropForeignKey
ALTER TABLE "subscription" DROP CONSTRAINT "subscription_userId_fkey";

-- DropTable
DROP TABLE "diarium_parameter";

-- DropTable
DROP TABLE "diarium_result";

-- DropTable
DROP TABLE "diarium_search";

-- DropTable
DROP TABLE "notification";

-- DropTable
DROP TABLE "refresh";

-- DropTable
DROP TABLE "role";

-- DropTable
DROP TABLE "session";

-- DropTable
DROP TABLE "subscription";

-- DropTable
DROP TABLE "user";

-- CreateTable
CREATE TABLE "diarium_searches" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "hitCount" TEXT NOT NULL,

    CONSTRAINT "diarium_searches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "diarium_parameters" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "diariumSearchId" UUID NOT NULL,
    "name" "DiariumParameterName" NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "diarium_parameters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "diarium_results" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "diariumSearchId" UUID NOT NULL,
    "caseName" TEXT NOT NULL,
    "companyName" TEXT NOT NULL,
    "documentCode" TEXT NOT NULL,
    "documentDate" TEXT NOT NULL,
    "documentType" TEXT NOT NULL,

    CONSTRAINT "diarium_results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "subscriptionId" UUID NOT NULL,
    "refreshId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "emailStatus" "NotificationEmailStatus" NOT NULL,
    "caseName" TEXT NOT NULL,
    "companyCode" TEXT NOT NULL,
    "documentCode" TEXT NOT NULL,
    "documentDate" TEXT NOT NULL,
    "documentType" TEXT NOT NULL,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refreshes" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "subscriptionId" UUID NOT NULL,
    "diariumSearchId" UUID NOT NULL,

    CONSTRAINT "refreshes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" UUID NOT NULL,
    "name" "RoleName" NOT NULL,
    "status" "RoleStatus" NOT NULL,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sessions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" UUID NOT NULL,
    "secret" TEXT NOT NULL,
    "status" "SessionStatus" NOT NULL,

    CONSTRAINT "sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscriptions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" UUID NOT NULL,
    "companyCode" TEXT NOT NULL,

    CONSTRAINT "subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- AddForeignKey
ALTER TABLE "diarium_parameters" ADD CONSTRAINT "diarium_parameters_diariumSearchId_fkey" FOREIGN KEY ("diariumSearchId") REFERENCES "diarium_searches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "diarium_results" ADD CONSTRAINT "diarium_results_diariumSearchId_fkey" FOREIGN KEY ("diariumSearchId") REFERENCES "diarium_searches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_refreshId_fkey" FOREIGN KEY ("refreshId") REFERENCES "refreshes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES "subscriptions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refreshes" ADD CONSTRAINT "refreshes_diariumSearchId_fkey" FOREIGN KEY ("diariumSearchId") REFERENCES "diarium_searches"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refreshes" ADD CONSTRAINT "refreshes_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES "subscriptions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "roles" ADD CONSTRAINT "roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
