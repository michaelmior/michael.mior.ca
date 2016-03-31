---
title: DBUS for cross-machine screensaver locking
author: michaelmior
date: 2010-10-12
template: article.jade
summary: "DBUS signals in gnome-screensaver can be used to synchronize locking and unlocking across multiple machines."
---

I typically work with two computers on a regular basis.
When I bring my laptop into the office, that makes three.
I have a habit of locking my computer(s) when I step out, but it gets to be a pain when I have three machines running at once.
I decided that I wanted to be able to lock one machine, and have the rest follow suit.
I discovered that this is possible using DBUS since gnome-screensaver emits a signal whenever locking status is changed.
I turned to my trusty Python, and started hacking away.

Without further ado, here is the code:

~~~ python
#!/usr/bin/python

import dbus
from dbus.mainloop.glib import DBusGMainLoop
import gobject
import os

# Hosts which should be locked/unlocked
hosts = ['starks', 'mmior-laptop']
# Set to True to turn on displays of other
# hosts after unlocking
wake = False

def toggle_lock(x):
  if x == 0:
    for host in hosts:
      os.system('ssh ' + host + ' export DISPLAY=:0; gnome-screensaver-command -d')
      if wake:
        os.system('ssh ' + host + ' export DISPLAY=:0; xset dpms force on; gnome-screensaver-command -d')
  if x == 1:
    os.system('xset s activate')
    for host in hosts:
      os.system('ssh ' + host + ' export DISPLAY=:0; xset dpms force off; gnome-screensaver-command -l')

DBusGMainLoop(set_as_default=True)

# Connect to the session bus and
# install our signal handler
bus = dbus.SessionBus()
bus.add_signal_receiver(toggle_lock,
  'ActiveChanged',
  'org.gnome.ScreenSaver',
  path='/org/gnome/ScreenSaver')

# Start the loop and wait for the signal
gobject.MainLoop().run()

# Clean up by removing the signal handler
bus.remove_signal_receiver(toggle_lock,
  'ActiveChanged',
  'org.gnome.ScreenSaver',
  path='/org/gnome/ScreenSaver')
~~~

This needs to be run as a daemon in the background to watch for the signal.
To use the script, just replace the hosts array with a list of hostnames you wish to lock/unlock.
The wake variable controls whether or not the screens of the other machines should be turned on when unlocked.
Of course you can add any actions you wish to take on lock/unlock.

For more information, check out the [Python DBUS tutorial](http://dbus.freedesktop.org/doc/dbus-python/doc/tutorial.html) or see how to use [`dbus-monitor`](http://linux.die.net/man/1/dbus-monitor) to watch for any signals going over the bus.

If you want to poke around and see what DBUS interfaces various programs you have installed, check out the Debian package `qt4-dev-tools`.
It may be a little big since it requires installing lots of Qt libraries, but the included `qdbusviewer` tool is great for browsing signals and testing out message sending.

If you run into any problems or come up with a cool use case, let me know in the comments!
