import prisma from './database'

export async function findNewestArtefactDate(
  countyId: string
): Promise<Date | undefined> {
  const newestStub = await prisma.stub.findFirst({
    where: {
      countyId: countyId,
    },
    orderBy: {
      filed: 'desc',
    },
  })
  if (newestStub) {
    return new Date(newestStub.filed)
  }

  const newestDocument = await prisma.document.findFirst({
    where: {
      countyId: countyId,
    },
    orderBy: {
      filed: 'desc',
    },
  })
  if (newestDocument) {
    return new Date(newestDocument.filed)
  }
}
