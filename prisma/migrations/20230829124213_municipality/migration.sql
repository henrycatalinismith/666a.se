-- CreateTable
CREATE TABLE "municipality" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "countyId" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "municipality_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "municipality_code_key" ON "municipality"("code");

-- CreateIndex
CREATE UNIQUE INDEX "municipality_slug_key" ON "municipality"("slug");

-- AddForeignKey
ALTER TABLE "municipality" ADD CONSTRAINT "municipality_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "county"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
