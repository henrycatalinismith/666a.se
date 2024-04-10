# Service Architecture Diagram

```mermaid
flowchart TD
    GitHub -->|deploys| Fly
    Fly -->|errors| Sentry
    Loopia -->|nameserver| Cloudflare
    Cloudflare -->|dns| Fly
    Cloudflare -->|dns| SendGrid
    Fly -->|smtp| SendGrid
```