---
title: User Module
layout: architecture
---

# User Module

## Entity Relationship Diagram

<div class="not-prose">
  <pre class="mermaid">
    erDiagram

      "User::Account" {
          string id  
          datetime created_at  
          datetime updated_at  
          string email  
          string encrypted_password  
          string reset_password_token  
          datetime reset_password_sent_at  
          datetime remember_created_at  
          string name  
          string company_code  
          string locale  
      }

      "User::Account" ||--o{ "User::Role" : ""

      "User::Role" {
          string id  
          datetime created_at  
          datetime updated_at  
          string account_id  
          integer name  
      }

      "User::Account" ||--o{ "User::Subscription" : ""

      "User::Subscription" {
          string id  
          datetime created_at  
          datetime updated_at  
          string account_id  
          string company_code  
          integer subscription_status  
          integer subscription_type  
          string workplace_code  
      }

      "User::Subscription" ||--o{ "User::Notification" : ""

      "User::Notification" {
          string id  
          datetime created_at  
          datetime updated_at  
          string document_id  
          string subscription_id  
          integer email_status  
      }

  </pre>
</div>
