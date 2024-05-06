---
title: Labour Law Module
---

# Labour Law Module

## Entity Relationship Diagram

<div class="not-prose">
  <pre class="mermaid">
    erDiagram

      "LabourLaw::Document" {
          string id
          datetime created_at
          datetime updated_at
          string document_name
          string document_code
          string document_slug
      }

      "LabourLaw::Document" ||--o{ "LabourLaw::Revision" : ""

      "LabourLaw::Revision" {
          string id
          datetime created_at
          datetime updated_at
          string document_id
          string revision_name
          string revision_code
          string revision_notice
          integer revision_status
      }

      "LabourLaw::Revision" ||--o{ "LabourLaw::Element" : ""

      "LabourLaw::Element" {
          string id
          datetime created_at
          datetime updated_at
          string revision_id
          string element_type
          string element_slug
          string element_text
          string element_chapter 
          string element_section 
          string element_paragraph 
          decimal element_index
      }

      "LabourLaw::Element" ||--o{ "LabourLaw::Translation" : ""

      "LabourLaw::Translation" {
          string id
          datetime created_at
          datetime updated_at
          string element_id
          string translation_locale
          string translation_text
      }

  </pre>
</div>
