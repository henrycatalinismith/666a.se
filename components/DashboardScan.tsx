'use client'

import { Chunk, Scan, Stub } from '@prisma/client'
import { ScanIcon } from 'entities/Scan'
import _ from 'lodash'
import Link from 'next/link'
import { FC } from 'react'
import { Card } from 'ui/Card'
import { Progress } from 'ui/Progress'

export type DashboardScanProps = {
  chunks: Chunk[]
  scan: Scan
  stubs: Stub[]
}

export const DashboardScan: FC<DashboardScanProps> = ({
  chunks,
  scan,
  stubs,
}) => {
  const progress =
    (_.filter([...stubs, ...chunks], { status: 'SUCCESS' }).length /
      (chunks.length + stubs.length)) *
    100

  return (
    <Card className="p-8 mt-8 mb-8 ">
      <div className="flex scroll-m-20 font-bold tracking-tight flex-row items-center gap-2">
        <Link
          className="border-black border-4 rounded-full w-16 h-16 min-w-[4rem] flex items-center justify-center"
          href={`/scans/${scan.id}`}
        >
          <ScanIcon className="h-8" />
        </Link>
        <div className="flex flex-col min-w-0 flex-1">
          <p className="text-1xl whitespace-nowrap overflow-hidden text-ellipsis">
            {`${scan.date?.toISOString().substring(0, 10)}`}
          </p>
          <Progress value={progress} className="w-full" />
        </div>
      </div>
    </Card>
  )
}
