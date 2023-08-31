import _ from 'lodash'

import { Card } from '../../components/Card'
import NavBar from '../../components/NavBar'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '../../components/Table'
import { requireUser } from '../../lib/authentication'
import prisma from '../../lib/database'

export default async function Statistics() {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const companyCount = await prisma.company.count()

  return (
    <>
      <NavBar />
      <div className="container">
        <Card className="mt-4 p-4 w-[380px]">{companyCount}</Card>
      </div>
    </>
  )
}
