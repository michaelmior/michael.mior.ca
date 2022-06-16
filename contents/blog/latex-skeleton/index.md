---
title: LaTeX Skeleton
author: michaelmior
date: 2018-03-02
template: article.jade
summary: "This is a quick overview of a template that I use when writing papers using LaTeX."
image: scroll.png
---

A repeated task I run into when I start working on a new paper is the laying out the initial structure of the repository to store the paper text.
I recently pushed [a simple skeleton](https://github.com/michaelmior/latex-skeleton) that I use a starting point to GitHub.
There's nothing really fancy here, but it's a good starting point.
I use [latexmk](https://mg.readthedocs.io/latexmk.html) to build all my documents since it takes care of running BibTeX among other things.
One of the nice other things is that it will automatically try to use `make` to build any missing files.
The repository basically consists of a `Makefile` that generates the paper along with a simple LaTeX skeleton and an empty BibTeX file.
Hope it might be helpful to someone else!
