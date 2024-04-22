---
title: Work Environment Jobs
layout: tech
---

# Work Environment Jobs

<div class="not-prose">
  <pre class="mermaid">
  flowchart TD
      A[WorkEnvironment::MorningJob] -->  B
      B[WorkEnvironment::DayJob] --> B
      B[WorkEnvironment::DayJob] --> C
      C[WorkEnvironment::SearchJob] --> D
      D[WorkEnvironment::ResultJob] --> E
      E[WorkEnvironment::DocumentJob] --> F
      F[User::NotificationJob] --> G
      G[User::EmailJob]
  </pre>
</div>