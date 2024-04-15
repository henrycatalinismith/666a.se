---
title: Incident Report
date: 2023-12-03
layout: post
---

# Incident Report

This weekend there was a minor incident where 666a over-alerted a little bit, resulting in a total of less than 100 email alerts to be sent in error. No data loss or privacy breaches occurred as part of this incident, just a few emails getting sent that shouldn't have.

Here's the explanatory email I sent to the folks who got some unnecessary emails.

> Hey folks
>
> Earlier today 666a went a bit haywire and started sending loads of email notifications about arbetsmiljöverket filings from April. It’s fixed now and you shouldn’t see any more.
>
> I take operating this service really seriously and wanted to get in touch and explain. I’ve been tweaking the diarium update algorithm this week to try to avoid missing documents if they’re filed late and then backdated to earlier in the week. While doing so I made a small coding mistake that turned on email notifications for all documents.
>
>Normally only a fraction of documents get email notifications sent about them. I’ve got 666a slowly backfilling its database with the entire 2023 dataset because I think I can operate the service best with at least one complete year of data history. Email notifications are switched off for those historical documents but my change this week accidentally turned them on.
>
> Rest assured it won’t happen again, and as you can tell I'm very biased towards overalerting rather than ever risk someone missing something, so I think that's at least not completely terrible.
>
> Henry