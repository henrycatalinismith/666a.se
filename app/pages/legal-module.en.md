---
title: Legal Module
---

# Legal Module

## Entity Relationship Diagram

<div class="not-prose">
  <pre class="mermaid">
    erDiagram

      "Legal::Document" {
          string id  
          datetime created_at  
          datetime updated_at  
          string document_name  
          string document_code  
      }

      "Legal::Document" ||--o{ "Legal::Revision" : ""

      "Legal::Revision" {
          string id  
          datetime created_at  
          datetime updated_at  
          string document_id  
          string revision_name  
          string revision_code  
      }

      "Legal::Revision" ||--o{ "Legal::Element" : ""

      "Legal::Element" {
          string id  
          datetime created_at  
          datetime updated_at  
          string revision_id  
          string element_type  
          string element_code  
          string element_text  
          decimal element_index  
      }

      "Legal::Element" ||--o{ "Legal::Translation" : ""

      "Legal::Translation" {
          string id  
          datetime created_at  
          datetime updated_at  
          string element_id  
          string translation_locale  
          string translation_text  
      }

  </pre>
</div>
