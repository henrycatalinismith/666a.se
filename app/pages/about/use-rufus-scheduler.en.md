---
title: Use Rufus-Scheduler
layout: decision
date: 2023-09-28
---

# Use Rufus-Scheduler

## Context

666a needs a way to schedule background jobs. Ideally the chosen solution should not impose any new infrastructure costs on top of the Rails app hosting. A few hundred jobs are scheduled per day, with a predictable and steady rhythm that does not scale in proportion to signups or traffic.

## Decision

The [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler) gem fits the use case perfectly.

## Alternatives Considered

The most commonly chosen solution for anything job-related in Rails apps is [sidekiq](https://github.com/sidekiq/sidekiq). That option requires adding a Redis server to the production infrastructure, which increases hosting costs. Additionally, [sidekiq's cron functionality](https://github.com/sidekiq/sidekiq/wiki/Ent-Periodic-Jobs) is only available on their enterprise billing tier.

Other common choices include [resque](https://github.com/resque/resque) and [good_job](https://github.com/bensheldon/good_job). Both of these require additional backend storage systems (Redis and Postgres respectively).

## Consequences

Rufus-scheduler enables 666a to schedule daily jobs without adding any additional infrastructure. The scheduler runs in-memory as part of the Rails app process.

The trade-off of running the jobs in memory like this is that restarting the app will terminate any running jobs. So a deploy during an important job can potentially leave some unfinished business somewhere. As the jobs run during Swedish daytime business hours when no 666a development occurs, this should rarely cause any trouble in practice.
