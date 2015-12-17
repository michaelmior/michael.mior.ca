---
title: Automated Testing of Dotfiles
created_at: 24 September 2015
kind: article
---
Several years ago I started managing my dotfiles based on Zach Holman's [dotfiles repo](https://github.com/holman/dotfiles).
His setup is quite nice and I found it relatively easy to adapt to my own purposes.
My workflow generally consisted of making a bunch of local changes until I was happy and then pushing to my own [GitHub fork](https://github.com/michaelmior/dotfiles).

The big problem I eventually found is that I wasn't fully capturing the correct steps to reproduce my environment.
Every time that I tried to install my dotfiles on a new machine, I would be met with several errors that I would eventually resolve.
The fix would not always result in something which was reproducible on another machine.
I wanted a solution that would let me automatically test that my dotfiles would cleanly install every time I pushed to GitHub, so I turned to [Docker](https://www.docker.com/).

Traditional CI services would have been a bit of a pain to use with all the packages that needed to be installed.
[Docker Hub](https://hub.docker.com/r/michaelmior/dotfiles/) made things nice and easy.
My [Dockerfile](https://github.com/michaelmior/dotfiles/blob/a9eae90d466958948a53b3b583d69eba844ed8f7/Dockerfile) simply installs the necessary OS packages, adds a new user and then tries to run my install script.
I currently don't have any other testing other than to ensure that the script exits without error, but this has already saved me a lot of trouble.

**Update**: I have since switched to using [Travis CI](https://travis-ci.org/michaelmior/dotfiles) as I do with my other projects. It turns out this is easier than I expected. I still haven't explicitly added any tests but even being able to confirm that the installation steps succeed is useful to ensure nothing breaks.
