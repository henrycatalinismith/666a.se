---
title: Night Work, Tech, And Swedish Labour Law
date: 2024-01-22
layout: post
---

# Night Work, Tech, And Swedish Labour Law

Last week’s [news about Spotify’s night work ruling from the administrative court](https://arbetet.se/2024/01/19/nattarbete-forbjuds-nu-kan-spotify-flytta-tjanster-utomlands/) was a landmark moment for the Swedish tech industry. It’s the latest in a series of news stories about tech employers trying and failing to circumvent the Swedish labour market model through legal maneuvers. There’s a clear pattern forming: it doesn’t work.

This was the original Work Environment Authority case that inspired the idea for [666a](https://666a.se). The case had a lot of twists and turns, and it was too easy to go a week without noticing an important new filing, so I longed for a [work environment email alert service](https://666a.se/) to inform me automatically. And then when something did come up, explaining it to people was made more difficult by the lack of linkable English translations of relevant legislation.

Now that the case is drawing to a close and my dream of being able to explain the story and its context in terms of the laws involved is finally possible, here’s a chronological walkthrough.

## The daily rest period

[Section 13 of the Swedish Working Hours Act](/labour-law/working-hours-act/2013:611/section-13) protects the right to a daily rest period. This must be at least 11 consecutive hours in a given 24 hour period. It must also include the hours between midnight and 05:00.

This is a problem for employers whose businesses involve software systems with the potential to break during those hours. In tech it’s commonplace to organise an on-call rota for this work, which means engineers take turns. If something breaks outside of normal business hours, a service like PagerDuty phones the engineer on call and wakes them up to fix the problem.

This practice isn’t legal in Sweden unless certain checks and balances are in place. Despite this, some tech employers have ignored the law, instructing employees to work during the night anyway.

## Safety representative training

[Chapter 6 Section 4 of the Swedish Work Environment Act](https://lagstiftning.github.io/arbetsmiljolagen/2023:349/chapter-6-section-4) creates a joint responsibility, shared by both employers and their employees, that safety representatives must receive the training necessary to perform their  role.

Ensuring that employers’ personnel practices are compliant with [the Working Hours Act](/labour-law/working-hours-act/2013:611) is exactly the kind of thing safety reps are meant to do. The Swedish tech industry’s low engagement with the country’s labour movement has enabled years of non-compliance by many employers. Safety representatives without union support – who may well receive all their training from the employer despite the clear conflict of interest this entails – often won’t notice the violation, or are easily instructed to ignore it.

This pattern is exactly why the government’s 2023 instructions to the work environment authority to increase the number of safety reps “regardless of union membership status” met with so much [backlash from the central unions](https://www.arbetsvarlden.se/regeringen-oppnar-for-fler-skyddsombud-utan-facktillhorighet/). Safety reps without union support are easily sidelined. It’s my understanding that cases of full-blown employer co-optation of entire work environment committees aren't unheard of.

## Exemptions by the Work Environment Authority

[Section 19 of the Swedish Working Hours Act](/labour-law/working-hours-act/2013:611/section-19) gives the Work Environment Authority the power to grant exemptions to [the night work ban imposed by section 13](/labour-law/working-hours-act/2013:611/section-13). In [2023/016334-18](https://www.av.se/om-oss/sok-i-arbetsmiljoverkets-diarium/?id=2023/016334-18), they explained the criteria for the exemptions in some detail.

> It appears from practice that the exemption option regarding the night work ban must be applied restrictively and is intended for situations that satisfy important societal interests and urgent service needs.
> 
> The work that is granted an exemption from the night work ban thus either needs to support a directly exempt activity or in itself be of great societal interest. It is also required that there is an important societal interest in the work being carried out at night.

In blunt terms, "we make more money when the servers are up" doesn't cut it. If you're a SaaS business and one of your customers depends on your product to deliver a socially critical service then you can still get an exemption because of that, but otherwise there's only one other route to legal night work. 

## Legal night work through collective bargaining

[Section 3 of the Swedish Working Hours Act](/labour-law/working-hours-act/2013:611/section-3) grants workers the flexibility to negotiate away [the night work ban imposed by section 13](/labour-law/working-hours-act/2013:611/section-13) through collective bargaining with the employer.

This is one of my personal favourite Swedish laws. I think there's just such an instinctive fairness to it. To agree to be randomly awoken in the night to urgently defend your employer's business is to take a level of responsibility more commonly associated with a parent of a newborn baby. It's fair for workers willing to invest this much of themselves in a business to expect their employer to respect them as an equal counterpart in negotiations about working conditions and the like.

This is the point Spotify's founding team missed when [they first threatened to withdraw the company from Sweden back in 2016](https://medium.com/@SpotifySE/vi-m%C3%A5ste-agera-eller-bli-omsprungna-383bb0b808eb#.u5h5pqrva).

> Think how amazing it would be if Sweden became the country where the employees became part-owners of the companies where they work. It suits us and our culture perfectly. We as owners are prepared to share. If anything, politics should promote that ownership spreads and creates solidarity.

It sounds alright [superficially](https://www.theguardian.com/technology/2023/apr/11/techscape-zirp-tech-boom), but the words turns to ashes in your mouth once you understand that small-time shareholders don't have any meaningful say in working conditions compared to the co-determination already provided for by Sweden's world-leading labour law. Once you're being woken up at 03:00 to fix servers, the board's fiduciary duty to shareholders may even be in conflict with your most pressing material needs (i.e. a full night's sleep as often as possible). That's why I think [section 3](/labour-law/working-hours-act/2013:611/section-3) is such a clever piece of legal judo to empower workers. You're such a key worker that you sometimes need to get up in the night like a superhero? Then you get a seat at the table when big decisions are being made.
 
## Fines for non-compliance

[Section 24 of the Swedish Working Hours Act](/labour-law/working-hours-act/2013:611/section-24) imposes fines for employers who violate [the night work ban imposed by section 13](/labour-law/working-hours-act/2013:611/section-13).

I'm not as impressed with this law as I am with the flexibility of [section 3's compliance via collective bargaining](/labour-law/working-hours-act/2013:611/section-3). Klarna's fine was [1,094,471kr](https://kollega.se/arbetsmiljo/efter-arbetsmiljobrister-klarna-maste-betala-miljonbelopp) and Spotify's was only [356,000kr](https://kollega.se/arbetsratt/spotify-tvingas-betala-nattarbete-saknade-avtal). Fines this small are not a serious financial deterrent.

There is also the soft penalty of the brand damage an employer incurs by flouting labour laws, but most employers aren't as high profile as Klarna or Spotify, so this penalty is much smaller for them. And even in cases where this leverage exists, it's a severe flaw for the system to depend on individual union representatives or safety reps taking on the personal risk of actually using that leverage to achieve compliance. Fear of retaliation has a very powerful chilling effect.

## The right to appeal

[Section 29 of the Swedish Working Hours Act](/labour-law/working-hours-act/2013:611/section-29) makes it possible to appeal the Work Environment Authority's decisions in an administrative court.

Something I'll wonder about for the rest of my days is how much impact the events of the Tesla strike had on Spotify's appeal. In a regular year, I reckon the sheer brand power that Spotify wields in Swedish society might have been enough to browbeat an off-guard administrative court into granting their appeal.

But 2023 wasn't a regular year. Of particular note were [Tesla's failed Solna district court case](https://da.se/2023/12/annu-ett-bakslag-for-tesla-postnord-behover-inte-lamna-ut-skyltar/) and their [loss on appeal in the Norrköping district court](https://www.domstol.se/nyheter/2023/12/hovratten-upphaver-tingsrattens-tillfalliga-beslut-att-lata-tesla-hamta-registreringsskyltar-direkt-hos-tillverkaren/). I can't shake the feeling that all this racket Tesla made might have awoken an awareness among Sweden's legal profession that a couple of powerful employers were attempting a sudden Americanisation of the Swedish labour market through courtroom shenanigans.

## Enforcement

[Section 22 of the Swedish Working Hours Act](/labour-law/working-hours-act/2013:611/section-22) empowers the Work Environment Authority to issue any prohibitions necessary to get employers to follow the law. [Section 23](/labour-law/working-hours-act/2013:611/section-23) imposes penalties ranging from fines to up to a year of imprisonment for failure to comply with prohibitions under section 22.

It seems unlikely the Spotify case will come to this. Their stance is clear: they'll instruct their overseas workforce to pick up these tasks rather than engage in collective bargaining with their Swedish workforce.

I think that's a really exciting move – part of a strategy conceived in early 2023, when they filed for their night work ban exemption the day after the formation of the Spotify Unionen club. Back then, it had been years since Unionen had last invoked [section 45 of the Swedish Co-Determination Act
](/labour-law/codetermination-act/2021:1114/section-45), which I bet made this seem like more of a risk analysis slam dunk than it might seem now.