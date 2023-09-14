import _ from 'lodash'

import prisma from '../lib/database'
;(async () => {
  const day = await prisma.day.create({
    data: {
      date: new Date(process.argv[2]),
    },
  })

  console.log(day)

  process.exit(0)
})()
