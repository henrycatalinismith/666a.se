---
title: Operations
layout: tech
---

# Operations

## Monitoring

Back end errors are tracked using [Sentry](https://sentry.io/). Front end errors are untracked as there's no significant JavaScript in the critical path user journey.

## Environment Variables

### `RAILS_MASTER_KEY`

The Rails master key is for encrypting and decrypting [the credentials file](https://github.com/666ase/666a/blob/main/config/credentials.yml.enc). In 666a, that file is only used to store the `secret_key_base` which Rails puts in there by default. Rails uses that value to sign and encrypt cookies.

666a won't deploy without a `RAILS_MASTER_KEY` value. But it doesn't matter too much to deploy it with a _new_ value. The only downside would be that it'd log everyone out, and 666a isn't really the kind of service you need to interact with often, so who cares.

### `SENDGRID_API_KEY`

Without a SendGrid API key 666a can't send emails, so this one's very important. Once you have a SendGrid account, these keys can be generated on SendGrid's [API Keys page](https://app.sendgrid.com/settings/api_keys).

### `SENTRY_DSN`

The Sentry DSN is necessary for error tracking. 666a can probably run fine without this, but error tracking is worth having. Once you've set up a Rails project in Sentry, the settings page sidebar section titled "SDK Setup" contains a link labeled "Client Keys (DSN)". This link takes you to a page containing the value to use for this secret.