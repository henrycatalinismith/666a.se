---
title: About Arbetsmiljöverket's New Webdiarium
date: 2024-06-06
layout: post
---

# About Arbetsmiljöverket's New Webdiarium

The Work Environment Authority [shipped a completely new version of their web search tool last week](https://www.av.se/nyheter/2024/ny-e-tjanst-for-att-soka-och-bestalla-handlingar/), which took 666a’s email alerts out of action for a week. It’s fixed now.

This was always my nightmare scenario for 666a. The Work Environment Authority’s search tool was already looking very old when I built 666a. There’s a particular type of “looks old” where you can almost hear the team who maintain it arguing internally for a rewrite.

My fear was that the new version, when it inevitably came, would require JavaScript. The old version served results as plain server-rendered HTML, which is important for a service like 666a because it means you can scrape them quite efficiently with just an HTTP request and an HTML parser. The economics of providing this kind of email alert service would look a lot worse if it became dependent on headless browser automation due to a JavaScript-heavy rewrite of the search tool.

Thankfully this hasn’t happened. And for that, I’m very grateful to whoever’s behind this rewrite. Seriously, thank you. [The new version](https://www.av.se/om-oss/diarium-och-allmanna-handlingar/bestall-handlingar/) is lovely, by the way, so great job!!

Now that 666a’s an open source project, the full incident response process is public on GitHub. There’s even a project called “[Update the email alerts service for the Work Environment Authority's new web search tool](https://github.com/orgs/666ase/projects/6/views/1)” where you can get an overview of each individual task if you’re curious. Always happy to onboard new contributors so if it sparks your curiosity do reach out!