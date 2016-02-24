---
title: Designing an Offline CMS
author: michaelmior
date: 2010-12-02
template: article.jade
summary: "Using a simple Makefile its, easy to build a CMS-like system that operates entirely offline."
---
First the obvious question.
What on earth is an offline CMS?
Isn't the whole point of having a CMS that you don’t have to change anything offline? Well, yes that’s true.
But recently I ran into a problem.

When I started my Masters degree, the department wanted me to create a webpage, but all I could really do was serve boring old static content.
Well, that's not entirely true, since there was an offer to set up a reverse proxy with my own LAMP stack, but that seemed like overkill for my humble little homepage.
I also knew that I sure didn’t want to have to edit pages one by one every time I wanted to change common content.
I also didn’t want to have to upload things manually every time things changed.

I did some searching around, and I decided to start with the [Cheetah](http://www.cheetahtemplate.org/) template engine.
It's got basically all the template goodness you need and a nice, clean syntax.
So I created some Cheetah templates, and wrote a little script to generate all my files, and everything worked just fine.
But I didn’t want to stop there.
So I decided to throw in some of the [goodness of SASS](http://wiseheartdesign.com/articles/2010/01/18/the-demise-of-css-why-sass-and-languages-like-it-will-triumph/).
(If you’re not familiar with SASS, check out the link, it’ll change your life.)
Finally, just for good measure, I decided to throw in cssoptimizer and [jsmin](http://www.crockford.com/javascript/jsmin.html) to pack everything down to size.

Finally, just to satisfy my aching fingers, I decided to write a Makefile that would perform the whole shebang: generate the static HTML, optimize JS and CSS code, and upload any changes to the server.

~~~ text
SERVER = yourserverhere

JS = $(wildcard src/js/*.js)
JS_OPT = $(patsubst src/js/%.js,web/js/%.js, $(JS))

SASS = $(wildcard src/sass/*.sass)
CSS = $(patsubst src/sass/%.sass,web/css/%.css, $(SASS))

TMPL = $(wildcard src/tmpl/*.tmpl)
TMPL_INC = $(wildcard src/tmpl/inc/*.tmpl)
HTM = $(patsubst src/tmpl/%.tmpl,web/%.htm, $(TMPL))

# Build all JavaScript, CSS, and XHTML files
all: $(JS_OPT) $(CSS) $(HTM)

# Remove all built files from the output directory
clean:
 rm -f web/*.htm
 rm -f web/js/*.js    rm -f web/css/*.css

# Upload the final site to the server
put: all
 rsync -avr --delete web/ $(SERVER):~/public_html

# Optimize JavaScript files
$(JS_OPT): web/js/%.js: src/js/%.js
 cat $< | ./bin/jsmin > $@

# Optimize CSS files
$(CSS): web/css/%.css: src/sass/%.sass
 sass $< | ./bin/cssoptimizer -i $@

# Ensure XHTML is rebuilt when included templates change
$(HTM): $(TMPL_INC)

$(HTM): web/%.htm: src/tmpl/%.tmpl
 (cd src/tmpl; cheetah fill --nobackup --oext=$(suffix $@) --odir=../../$(dir $@) $(notdir $<))
~~~

To get this to work for you, you should just be able to change `SERVER` to the address of your web server.
The directory structure I used looks like this:

* bin
* src
  * tmpl
    * inc
  * sass
  * js
* web
  * img

Finally, here’s a complete list of download locations for all the tools I used:

* [Sass – Syntactically Awesome Stylesheets](http://sass-lang.com/)
* [JSMIN, The JavaScript Minifier](http://www.crockford.com/javascript/jsmin.html)
* [CSS Optimizer](http://mabblog.com/cssoptimizer/download.html)

I found out when researching for this post that [Lakshmi Vyas](http://twitter.com/lakshmivyas) has already come up with a solution called [Hyde](http://ringce.com/hyde) for Python.
There is also [jekyll](http://jekyllrb.com/) which uses Ruby.
This just gives you more approaches to building a custom tool that suits your needs.

If you have any tips for generating static web content, post in the comments!
