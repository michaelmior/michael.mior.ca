---
title: MySQL Client Configuration
author: michaelmior
date: 2012-01-06
template: article.jade
summary: "The MySQL CLI has a useful configuration file that you can use to avoid retyping usernames and passwords."
---

Perhaps I'm the only one who didn’t know this, but a while back, I discovered a handy trick for configuring the MySQL client.
You can create a configuration file in your home directory, `~/.my.cnf` and set options for the MySQL client to use.
Really handy if you’re constantly connecting to the same server and tired of entering hostname and port parameters.

Here's an example:

~~~ text
[client]
host     = 127.0.0.1
user     = root
password = root
port     = 4040
~~~

That's it for this post.
If you know any other time-saving tips for MySQL, please share in the comments!
