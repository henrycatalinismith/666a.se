-- CreateEnum
CREATE TYPE "SubscribableType" AS ENUM ('Company');

-- CreateTable
CREATE TABLE "subscription" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "userId" UUID NOT NULL,
    "targetType" "SubscribableType" NOT NULL,
    "targetId" UUID NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "subscription_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "subscription" ADD CONSTRAINT "subscription_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription" ADD CONSTRAINT "company_subscribableId" FOREIGN KEY ("targetId") REFERENCES "company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
