---
title: Coloured SSH terminals
author: michaelmior
date: 2011-03-06
template: article.jade
summary: "By hooking into SSH clients, you can set different colour schemes per host in your terminal to make it clear where you're connected to."
image: terminal.png
---

With the looming prospect of deploying software to production systems and horror stories of accidental commands executed on production systems instead of development machines, I wanted to try to find a way to ensure this never happened to me.
My first thought was to change the background colour of the terminal as that would be a clear indicator of the system I'm connected to.
Unfortunately, gnome-terminal doesn't allow changing the background colour of a running terminal and I don’t always want to launch a new terminal to SSH.
Fortunately, I found a solution.

While doing some research on the possibility of changing the `gnome-terminal` background, I came across [ROXTerm](http://roxterm.sourceforge.net/).
ROXTerm has a DBUS interface which can be used to control profiles and colour scheme of an open terminal.
Unfortunately, the documentation on this interface is a little light.
Thanks to [shimon](http://news.ycombinator.com/user?id=shimon) for his comment on [this post](http://news.ycombinator.com/item?id=2089159) on Hacker News.

I created a new colour scheme titled "Warning" including a red background with the intent of using this in any terminals where I know I need to be extra careful.

~~~ text
dbus-send --session /net/sf/roxterm/Options net.sf.roxterm.Options.SetColourScheme string:$ROXTERM_ID "string:Warning"
~~~

The next step was to get this command executed every time I connect to one of these servers.
I first created a simple script to save some typing, `roxterm-colour`. I placed this in `~/bin` (make sure to add this to your `PATH`).

~~~ text
#!/bin/sh
if [ -n $ROXTERM_ID ]; then
dbus-send --session /net/sf/roxterm/Options net.sf.roxterm.Options.SetColourScheme string:$ROXTERM_ID "string:$1"
fi
~~~

Using a local ssh config file in `~/.ssh/config` allows you to set connection-specific options.
The configuration settings below show how the colour scheme can be changed whenever the production system is connected to.

~~~ text
Host prod
Hostname production.example.com
LocalCommand roxterm-colour Warning
~~~

Now I can connect via ssh prod and the colour changes as expected.
The remaining problem is resetting the colour scheme as soon as the connection is broken.
Unfortunately, SSH doesn’t have any option to allow the execution of a command when a connection is broken.
For this, I created a simple script to alias SSH and reset the colour scheme after the connection dies.
This sits in `~/bin/ssh`. In this case, you must ensure that `~/bin` comes before `/usr/bin` in your `PATH`.

~~~ text
#!/bin/sh
trap "roxterm-colour Tango" EXIT
/usr/bin/ssh $*
~~~

The `trap` command ensures that the colour scheme will be reset whenever the script exits (my default colour scheme is Tango).
Finally, I also found that if I open a new tab while SSHed into a coloured terminal, this tab will also take on the same colour.
Therefore, I also added roxterm-colour Tango to my .bashrc so the colour would be reset with every new terminal.

I'm pretty happy with this setup and hoping it will help keep me from making any disastrous mistakes.
I've now replaced gnome-terminal with roxterm as my default.
Know any other tips on avoiding mistakes for production systems?
Let me know in the comments!
