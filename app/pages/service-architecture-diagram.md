---
title: Service Architecture Diagram
layout: tech
---

# Service Architecture Diagram

<pre class="mermaid">
flowchart TD
    GitHub -->|deploys| Fly
    Fly -->|errors| Sentry
    Loopia -->|nameserver| Cloudflare
    Cloudflare -->|dns| Fly
    Cloudflare -->|dns| SendGrid
    Fly -->|smtp| SendGrid
</pre>