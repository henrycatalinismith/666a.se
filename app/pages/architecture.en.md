---
title: Architecture
layout: tech
---

# Architecture

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