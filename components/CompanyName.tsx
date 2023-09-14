'use client'

import { faTag } from '@fortawesome/free-solid-svg-icons'
import { Company } from '@prisma/client'
import {
  IconDefinitionListDefinition,
  IconDefinitionListIcon,
  IconDefinitionListItem,
  IconDefinitionListRow,
  IconDefinitionListTerm,
} from 'components/IconDefinitionList'
import { FC, useCallback } from 'react'

export type CompanyNameProps = {
  company: Company
}

export const CompanyName: FC<CompanyNameProps> = ({ company }) => {
  const onSave = useCallback(
    (name: string) => {
      fetch(`/api/companies/${company.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: name,
        }),
      })
    },
    [company.id]
  )
  return (
    <IconDefinitionListRow editable onSave={onSave}>
      <IconDefinitionListIcon icon={faTag} />
      <IconDefinitionListItem>
        <IconDefinitionListTerm>Name</IconDefinitionListTerm>
        <IconDefinitionListDefinition>
          {company.name}
        </IconDefinitionListDefinition>
      </IconDefinitionListItem>
    </IconDefinitionListRow>
  )
}
