import prisma from './database'

export async function findNewestArtefactDate(
  countyId: string
): Promise<Date | undefined> {
  const newestStub = await prisma.stub.findFirst({
    where: {
      countyId: countyId,
    },
    orderBy: {
      documentDate: 'desc',
    },
  })
  if (newestStub) {
    return new Date(newestStub.documentDate)
  }

  const newestDocument = await prisma.document.findFirst({
    where: {
      countyId: countyId,
    },
    orderBy: {
      date: 'desc',
    },
  })
  if (newestDocument) {
    return new Date(newestDocument.date)
  }
}
