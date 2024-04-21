---
title: Use SQLite
layout: decision
date: 2023-09-25
---

# Use SQLite

## Status

Accepted

## Context

666a needs a database. The application averages less than 10000 writes per day and even fewer reads. The target audience is geographically concentrated within Sweden. Almost all the writes are internally scheduled by the application itself rather than triggered on demand by users. Due to the nature of the functionality, if the service acquired 1000 or even 10000 users, these read/write numbers would change by less than an order of magnitude. It's likely to take many years until the size of the database exceeds 1GB.

## Decision

SQLite will be the database engine.

## Alternatives Considered

Earlier iterations explored using [Vercel Postgres](https://vercel.com/docs/storage/vercel-postgres), [PlanetScale](https://planetscale.com/), and bare metal [Postgres](https://www.postgresql.org/).

Cloud databases are oriented towards a type of scaling that is not applicable to 666a. Load spikes and hockey stick growth are unlikely. So the downsides of those servies - mainly their high costs – are hardly worth suffering given the low impact of their upsides to this particular use case.

Bare metal Postgres was great in the context of prototyping 666a on a local machine. For a production deployment, that option requires deploying an additional service alongside the 666a Rails app. There's a certain amount of additional operational complexity associated with running multiple services, and 666a benefits from minimizing such costs as aggressively as possible.

## Consequences

SQLite brings certain scaling limitations. An unforeseen burst of viral attention might cause some temporary reliability issues, for example.

The Rails community is investing considerable effort into supporting the use of SQLite in production. Hosting provider Fly.io has done a lot of work on the specific combination of [SQLite & Rails in production](https://fly.io/ruby-dispatch/sqlite-and-rails-in-production/). The [litestack](https://github.com/oldmoe/litestack) gem simplifies the adoption process significantly. And [Stephen Margheim's tireless work](https://fractaledmind.github.io/2023/12/23/rubyconftw/) has played a crucial role too. SQLite used to be an odd choice for a production web application, but all this work is changing that.

Using SQLite will make it possible to encapsulate a full production deployment of 666a in a single Ruby process. That's unlikely to be sustainable forever, but the resulting operational simplicity will free up time to focus on developing the service itself.