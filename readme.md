# 666:a

## Setup

```bash
git clone git@github.com:henrycatalinismith/666a.git
```

## Docs

<dl>

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

## Dependencies

| Name   | Version  |
| ------ | -------- |
| Ruby   | 3.2.2    |
| Docker | 20.10.21 |
| SQLite | 3.39.5   |

## Environment

| Name               | Purpose                                        |
| ------------------ | ---------------------------------------------- |
| `RAILS_MASTER_KEY` | Encrypting and decrypting the credentials file |
| `SENDGRID_API_KEY` | Sending email alerts                           |
| `SENTRY_DSN`       | Error logging                                  |
