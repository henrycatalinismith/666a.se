'use client'

import { Chunk, County, Scan } from '@prisma/client'
import { ScanIcon } from 'entities/Scan'
import _ from 'lodash'
import { FC } from 'react'
import { Card } from 'ui/Card'
import { Progress } from 'ui/Progress'

export type DashboardScanProps = {
  chunks: Chunk[]
  county: County
  scan: Scan
}

export const DashboardScan: FC<DashboardScanProps> = ({
  chunks,
  county,
  scan,
}) => {
  const progress =
    (_.filter(chunks, { status: 'SUCCESS' }).length / chunks.length) * 100

  return (
    <Card className="p-8 mt-8 mb-8 ">
      <div className="flex scroll-m-20 font-bold tracking-tight flex-row items-center gap-2">
        <div className="border-black border-4 rounded-full w-16 h-16 min-w-[4rem] flex items-center justify-center">
          <ScanIcon className="h-8" />
        </div>
        <div className="flex flex-col min-w-0 flex-1">
          <p className="text-1xl whitespace-nowrap overflow-hidden text-ellipsis">
            {`${county!.name} ${scan.startDate
              ?.toISOString()
              .substring(0, 10)}`}
          </p>
          <Progress value={progress} className="w-full" />
        </div>
      </div>
    </Card>
  )
}
