---
title: Architectural Principles
layout: tech
---

# Architectural Principles

## 1. Simplicity

666a strives for simple solution designs. Sometimes complexity is inevitable. Ideally any complex solutions should be confined to as small an area as possible, without complicating the overall composition of the system.

For example, here's a rough diagram showing the relationships between some of the products that comprise the production 666a service.

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

There's no Kubernetes in this, because Kubernetes adds a great deal of complexity to solve a problem that 666a does not currently have.

## 2. Modularity

Logical groups of features should be abstracted away from each other as neatly as possible. When dependencies between modules arise, they should be handled thoughtfully and with particular regard to avoiding unnecessary coupling of internal details between modules.

For example, here's a diagram depicting some modules and the relationship between them.

<div class="not-prose">
  <pre class="mermaid">
    flowchart LR
      B(Work Environment) -->|notifies| A(User)
  </pre>
</div>

The work environment module keeps 666a up to date with public Work Environment Authority filings, but does not contain any personally identifiable information about which users should receive email alerts about which documents. Instead there is a one-way data flow of information about new documents from the work environment module to the user module.

## 3. Automation

Avoiding repetitive manual work is key for a best-effort basis volunteer work project like 666a. It's imperative that what little time is available to work on the service must be used as efficiently as possible.

Examples of tasks that should be as automatic as possible include testing and deploying changes, backing up and restoring the database, and detecting and resolving runtime errors.