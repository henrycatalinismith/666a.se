---
title: Work Environment Module
layout: architecture
---

# Work Environment Module

## Entity Relationship Diagram

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
