import {
  faArchive,
  faCalendarDay,
  faCode,
  faEnvelope,
  faPeopleGroup,
  faStamp,
} from '@fortawesome/free-solid-svg-icons'
import { RoleName } from '@prisma/client'

import {
  IconDefinitionList,
  IconDefinitionListDefinition,
  IconDefinitionListIcon,
  IconDefinitionListItem,
  IconDefinitionListRow,
  IconDefinitionListTerm,
} from 'components/IconDefinitionList'
import { SendButton } from 'components/SendButton'
import { NotificationIconDefinition } from 'entities/Notification'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

export default async function Notification({ params }: any) {
  const currentUser = await requireUser([RoleName.Developer])
  if (!currentUser) {
    return <></>
  }

  const notification = await prisma.notification.findFirstOrThrow({
    where: { id: params.id },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={NotificationIconDefinition}
          title="Notification"
          subtitle={`${notification.id}`}
          actions={[<SendButton key="send" id={notification.id} />]}
        />

        <IconDefinitionList>
          <IconDefinitionListRow>
            <IconDefinitionListIcon icon={faEnvelope} />
            <IconDefinitionListItem>
              <IconDefinitionListTerm>Email Status</IconDefinitionListTerm>
              <IconDefinitionListDefinition>
                {notification.emailStatus}
              </IconDefinitionListDefinition>
            </IconDefinitionListItem>
          </IconDefinitionListRow>

          <IconDefinitionListRow>
            <IconDefinitionListIcon icon={faPeopleGroup} />
            <IconDefinitionListItem>
              <IconDefinitionListTerm>Company Code</IconDefinitionListTerm>
              <IconDefinitionListDefinition>
                {notification.companyCode}
              </IconDefinitionListDefinition>
            </IconDefinitionListItem>
          </IconDefinitionListRow>

          <IconDefinitionListRow>
            <IconDefinitionListIcon icon={faCalendarDay} />
            <IconDefinitionListItem>
              <IconDefinitionListTerm>Document Date</IconDefinitionListTerm>
              <IconDefinitionListDefinition>
                {notification.documentDate}
              </IconDefinitionListDefinition>
            </IconDefinitionListItem>
          </IconDefinitionListRow>

          <IconDefinitionListRow>
            <IconDefinitionListIcon icon={faCode} />
            <IconDefinitionListItem>
              <IconDefinitionListTerm>Document Code</IconDefinitionListTerm>
              <IconDefinitionListDefinition>
                {notification.documentCode}
              </IconDefinitionListDefinition>
            </IconDefinitionListItem>
          </IconDefinitionListRow>

          <IconDefinitionListRow>
            <IconDefinitionListIcon icon={faStamp} />
            <IconDefinitionListItem>
              <IconDefinitionListTerm>Document Type</IconDefinitionListTerm>
              <IconDefinitionListDefinition>
                {notification.documentType}
              </IconDefinitionListDefinition>
            </IconDefinitionListItem>
          </IconDefinitionListRow>

          <IconDefinitionListRow>
            <IconDefinitionListIcon icon={faArchive} />
            <IconDefinitionListItem>
              <IconDefinitionListTerm>Case Name</IconDefinitionListTerm>
              <IconDefinitionListDefinition>
                {notification.caseName}
              </IconDefinitionListDefinition>
            </IconDefinitionListItem>
          </IconDefinitionListRow>
        </IconDefinitionList>
      </div>
    </>
  )
}
