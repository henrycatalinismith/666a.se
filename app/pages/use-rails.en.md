---
title: Use Rails
layout: decision
date: 2023-09-25
---

# Use Rails

## Context

666a needs a technical foundation. It's an application with a relatively simply UI, where most of the complexity lies in the back end and operational aspects. As an unfunded personal side project there's very little funding available for hosting services. The core functionality includes internationalization, job scheduling, and email sending. The data model is unclear and requires exploratory iterative development to determine.

## Decision

Rails is the right framework for this project. 

## Alternatives Considered

The project used Next.js for a several months during the early stages of development. Compared to ERB, React is the superior technology for rendering web content. Apart from that, the other significant advantage Next.js brings is the broader pool of potential collaborators.

Next.js lacks a built-in internationalization system. Third party options include [next-intl](https://next-intl-docs.vercel.app/), [next-i18next](https://github.com/i18next/next-i18next), [react-intl](https://www.npmjs.com/package/react-intl), [next-translate](https://github.com/aralroca/next-translate), [next-multilingual](https://github.com/Avansai/next-multilingual), and [typesafe-i18n](https://github.com/ivanhofer/typesafe-i18n). It also lacks a first party job queue framework, and the aftermarket options include [vercel cron jobs](https://vercel.com/blog/cron-jobs), [graphile worker](https://worker.graphile.org/), [bullmq](https://docs.bullmq.io/), [quirrel](https://quirrel.dev/), and [inngest](https://www.inngest.com/). There's no comparable alternative to Action Mailers that I'm aware of – presumably every Next.js improvises its own custom email sending setup or relies entirely on a premium SDK. The ORM options range from heavyweights like [Prisma](https://www.prisma.io/) to lighter query builders like [Kysely](https://kysely.dev/).

Some of the above mentioned solutions cost money. Others are part of freemium conversion funnels. In all cases, there's an upfront cost associated with evaluating, selecting and integrating a solution for each of these needs. More significantly, there's an ongoing maintenance cost associated with keeping those third party integrations in working order. Next.js is in the middle of an enormous architectural migration, which is causing a great deal of API churn in all of these third party add-ons. Even greater architectural changes are on the horizon for React. All of this leads to much more time consuming maintenance work just to keep an app up-to-date with security updates.

666a's UI complexity is quite low. So the positive impact of React's superiority as a piece of rendering technology is relatively limited. 666a's development resources are very sparse. So the negative impact of a high-maintenance tech stack is relatively severe.

## Consequences

The popularity of Rails peaked many years ago. One consequence of this is that the pool of potential 666a collaborators is smaller than – for example – the Next.js developer community. Another is that the ecosystem of open source packages is less vibrant, which could mean that there will be cases where open source solutions to problems exist for Next.js apps but not Rails ones.

The well-integrated and stable core of Rails features will enable fast iterative development of 666a with more time to focus on core functionality and less on dependency management busywork. Its [internationalization API](https://guides.rubyonrails.org/i18n.html) means it's ready to support the project's multilingual needs. The [Active Job](https://guides.rubyonrails.org/active_job_basics.html) framework provides the flexibility needed for 666a's challenging job scheduling problems. [Action Mailers](https://guides.rubyonrails.org/action_mailer_basics.html) facilitate sending automated email alerts to users. The flexibility of [Active Record](https://guides.rubyonrails.org/active_record_basics.html) and its [migration functionality](https://guides.rubyonrails.org/active_record_migrations.html) will support the evolution of the data model. The way Rails integrates all of this tightly into a single application enables it to be hosted on a single server, thus avoiding the significant operating costs of a more sprawling cloud architecture. The Rails team maintains a very high standard of backwards compatibility and long term API stability, which keeps maintenance costs low without forfeiting occasional security updates and new features.