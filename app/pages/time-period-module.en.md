---
title: Time Period Module
---

# Time Period Module

## Entity Relationship Diagram

<div class="not-prose">
  <pre class="mermaid">
    erDiagram

      "TimePeriod::Week" {
          string id  
          datetime created_at  
          datetime updated_at  
          string week_code  
      }

      "TimePeriod::Week" ||--o{ "TimePeriod::Day" : ""

      "TimePeriod::Day" {
          string id  
          datetime created_at  
          datetime updated_at  
          date date  
          integer ingestion_status  
          string week_id  
          decimal request_count  
      }

  </pre>
</div>