---
title: Use Rails
layout: decision
date: 2023-09-25
---

# Use Rails

## Status

Accepted

## Context

666a needs a technical foundation. It's an application with a relatively simply UI, where most of the complexity lies in the back end and operational aspects. As an unfunded personal side project there's very little funding available for hosting services. The core functionality includes internationalization, job scheduling, and email sending. The data model is unclear and requires exploratory iterative development to determine.

## Decision

Rails is the right framework for this project. Its [internationalization API](https://guides.rubyonrails.org/i18n.html) means it's ready to support the project's multilingual needs. The [Active Job](https://guides.rubyonrails.org/active_job_basics.html) framework provides the flexibility needed for 666a's challenging job scheduling problems. [Action Mailers](https://guides.rubyonrails.org/action_mailer_basics.html) facilitate sending automated email alerts to users. The flexibility of [Active Record](https://guides.rubyonrails.org/active_record_basics.html) and its [migration functionality](https://guides.rubyonrails.org/active_record_migrations.html) will support the evolution of the data model. The way Rails integrates all of this tightly into a single application enables it to be hosted on a single server, thus avoiding the significant operating costs of a more sprawling cloud architecture.

## Consequences
