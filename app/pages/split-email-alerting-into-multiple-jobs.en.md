---
title: Split Email Alerting Into Multiple Jobs
layout: decision
date: 2023-10-14
---

# Split Email Alerting Into Multiple Jobs

## Context

Email alerting requires the implementation of a sequence of automated steps. First, the system must check for new public filings at the Work Environment Authority. Then, it must determine which filings require email alerts to be sent. Finally, it must generate and send those emails. The solution to this problem takes the form of one or more Active Job classes, which need to be structured in a coherent way.

## Decision

The steps should be separated into as fine a granularity as possible, with each step having its own dedicated Active Job class. The completion of one step should automatically trigger the execution of the next.

## Alternatives Considered

The early exploration of this problem space led to large monolithic do-everything jobs. All the logic for fetching data from the Work Environment Authority's online service, caching it, parsing it, filtering it, iterating over it, and sending email alerts about it was colocated in the same Active Job class.

This approach produced job code that was easier to understand. Colocating the code reduced its surface area by eliminating boundaries between stages of the email alerting process. The entire alerting system could be read from top to bottom like a recipe for a meal.

However, email alerting is a problem that depends on external systems. The Work Environment Authority's website may go offline temporarily, or their response format may suddenly change. The system may exhaust its email sending quota, or the email provider may go offline temporarily. From an operational perspective, a monolithic do-everything job is problematic under these circumstances. It's difficult to tell the system to pick up where it left off, so the complexity of the manual intervention is much greater.

## Consequences

Separating the email alerting process into multiple jobs enables the creation of manually dispatchable jobs for any stage of the process. It enables the creation of admin UIs containing buttons to – for example – retry sending an email notification, or retry fetching a response from the Work Environment Authority's website.

The trade-off is that the system has a steeper initial learning curve due to the increaed surface area. Instead of one job, there are several. Engineering work on the system requires the developer to read multiple files and memorise the relationships between them, at least for a short while.
