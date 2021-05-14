---
title: Zotero reMarkable sync
date: 2018-03-23
summary: "With a reverse-engineered reMarkable API now available, I built a quick script to upload documents from Zotero to my reMarkable tablet."
image: sync.png
---

I've really been enjoying my [reMarkable](https://remarkable.com/) tablet the past several months.
(I wrote [a short review](/blog/remarkable-review/) last year if you care to see a few more details).
One of the biggest gripes I have about the device is that it can be a pain to get documents on it.
There's currently no web app so the only choice is desktop apps for Windows and macOS or a mobile app for Android.
Once I saw someone had released a [reMarkable API](https://github.com/splitbrain/ReMarkableAPI) on GitHub, I knew I would have to find some way to ease my pain.

I use [Zotero](https://www.zotero.org/) to manage my paper references and unsurprisingly, reading papers is one of the primary uses of my reMarkable.
I decided to figure out a way I could have new papers I wanted to read in Zotero show up on my reMarkable.
Using the reMarkable and Zotero APIs, this proved to be a fairly straightforward weekend project.
You can find the result [on GitHub](https://github.com/michaelmior/zotero-remarkable).

To get started, there are simply a few environment variables that need to be set which are detailed in the README.
Then once the script is run, it will look for items in a Zotero collection, download their attachments, and upload them to the reMarkable API.
Putting this script into a cron job means that my papers are now synchronized regularly.
I'm currently hosting this for myself for free on Heroku using the [scheduler add-on](https://devcenter.heroku.com/articles/scheduler) to run the job.
I disabled any web process (`heroku ps:scale web=0`) so the only thing that runs is the cron job.
Since the cron job is quite quick to run, it falls well within the free usage limits of Heroku.

I may decide to add a [Heroku button](https://devcenter.heroku.com/articles/heroku-button) to the repository in the future, but it's fairly straightforward to configure manually.
Just set the required environment variables, disable the web dyno, and set up the cron job with the scheduler.
Hope this ends up being useful to someone else!
