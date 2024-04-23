---
title: Architecture
layout: tech
---

# Architecture

## System Diagram

<div class="not-prose">
  <pre class="mermaid">
    flowchart TD
      GitHub -->|deploys| Fly
      Fly -->|errors| Sentry
      Loopia -->|nameserver| Cloudflare
      Cloudflare -->|dns| Fly
      Cloudflare -->|dns| SendGrid
      Fly -->|smtp| SendGrid
  </pre>
</div>

## Work Environment

<div class="not-prose">
  <pre class="mermaid">
    erDiagram

        "WorkEnvironment::Search" {
            string id  
            datetime created_at  
            datetime updated_at  
            string day_id  
            integer page_number  
            integer result_status  
            string hit_count  
        }

        "WorkEnvironment::Search" ||--o{ "WorkEnvironment::Result" : ""

        "WorkEnvironment::Result" {
            string id  
            datetime created_at  
            datetime updated_at  
            string search_id  
            integer metadata_status  
            string document_code  
            string case_name  
            string document_type  
            string document_date  
            string organisation_name  
            string metadata  
            integer document_status  
        }

        "WorkEnvironment::Result" ||--|| "WorkEnvironment::Document" : ""

        "WorkEnvironment::Document" {
            string id  
            datetime created_at  
            datetime updated_at  
            string document_code  
            date document_date  
            integer document_direction  
            string document_type  
            string case_code  
            string case_name  
            integer case_status  
            string company_code  
            string company_name  
            string workplace_code  
            string workplace_name  
            string county_code  
            string county_name  
            string municipality_code  
            string municipality_name  
            date case_date  
        }

  </pre>
</div>

## Legal Translations

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