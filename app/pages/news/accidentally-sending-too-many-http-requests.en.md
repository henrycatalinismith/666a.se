---
title: Accidentally Sending Too Many HTTP Requests
date: 2024-11-30
layout: post
---

# Accidentally Sending Too Many HTTP Requests

Arbetsmiljöverket [updated their webdiairum back in June](/news/about-arbetsmiljoverkets-new-webdiarium). When I [updated 666a to work with their new system](https://github.com/henrycatalinismith/666a.se/commit/1c2e2cf20a9c6650c18a8b2d7020d82b30dda99b), I made a coding mistake. The impact of my mistake was that 666a began to send more and more HTTP requests to Arbetsmiljöverket's webdiarium with each day that passed after the mistake.

This was the kind of mistake where it doesn't have very much impact at first, but the impact quietly grows and grows. These are the worst. They're so easy to miss because of how subtle they are on the day you ship them. And then by the time you do notice them, they've grown into a monster. By the time I caught this, it was causing something like 10000 extra HTTP requests per day.

![Graph showing a surge in growth around June](/search-growth-bug.png)

It's [fixed](https://github.com/henrycatalinismith/666a.se/commit/68a7c459335021dfe63b8fc358f68be9b7aba8ae) now. Sorry, Arbetsmiljöverket. I hope the system extra load didn't cause any trouble, although to be honest I doubt I'm the only one monitoring the webdiarium in this way so perhaps it wasn't even noticeable on your end. You can [email me](mailto:henry@666a.se) any time if you ever need to have a word with me about something like this.