# 666a.se

## Setup

```bash
git clone git@github.com:henrycatalinismith/666a.se.git
```

## Docs

<dl>

  <dt>
    <a href="https://github.com/henrycatalinismith/666a.se/blob/main/docs/dependency-version-numbers.md">
      Dependency Version Numbers
    </a>
  </dt>
  <dd>
    Some of the key system dependencies and known compatible version numbers.
  </dd>

  <dt>
    <a href="https://github.com/henrycatalinismith/666a.se/blob/main/docs/service-architecture-diagram.md">
      Service Architecture Diagram
    </a>
  </dt>
  <dd>
    Visual map of the various components that deliver the 666a service.
  </dd>

  <dt>
    <a href="https://github.com/henrycatalinismith/666a.se/blob/main/docs/work-environment-jobs.md">
      Work Environment Jobs
    </a>
  </dt>
  <dd>
    A guide to the relationships between the work environment jobs.
  </dd>

</dl>

## Environment

| Name               | Purpose                                        |
| ------------------ | ---------------------------------------------- |
| `RAILS_MASTER_KEY` | Encrypting and decrypting the credentials file |
| `SENDGRID_API_KEY` | Sending email alerts                           |
| `SENTRY_DSN`       | Error logging                                  |
