'use client'

import { faTag } from '@fortawesome/free-solid-svg-icons'
import {
  IconDefinitionListDefinition,
  IconDefinitionListIcon,
  IconDefinitionListItem,
  IconDefinitionListRow,
  IconDefinitionListTerm,
} from 'components/IconDefinitionList'
import { FC, useCallback } from 'react'

export type CompanyCodeProps = {
  subscriptionId: string
  companyCode: string
}

export const CompanyCode: FC<CompanyCodeProps> = ({
  subscriptionId,
  companyCode,
}) => {
  const onSave = useCallback(
    (companyCode: string) => {
      fetch(`/api/subscriptions/${subscriptionId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          companyCode: companyCode,
        }),
      })
    },
    [subscriptionId]
  )
  return (
    <IconDefinitionListRow editable onSave={onSave}>
      <IconDefinitionListIcon icon={faTag} />
      <IconDefinitionListItem>
        <IconDefinitionListTerm>Company Code</IconDefinitionListTerm>
        <IconDefinitionListDefinition>
          {companyCode}
        </IconDefinitionListDefinition>
      </IconDefinitionListItem>
    </IconDefinitionListRow>
  )
}
