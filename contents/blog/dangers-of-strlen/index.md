---
title: The Dangers of strlen
author: michaelmior
date: 2010-10-31
template: article.jade
summary: "When used carelessly, strlen can be a significant bottleneck in an application doing heavy string manipulation."
---
I’ll keep this post brief, but I wanted to share something I just found about the C `strlen` function. It’s slow. It can make a big difference in program execution time.

For example, I had a function in an external which consumes a string, so I call `strdup` each time around a loop to make sure I have a copy for the next iteration.

In my case, the function I was calling already had the length of the string passed in as a parameter. This means `s2 = strdup(s1);` can be rewritten as

~~~ c
s2 = (char*) malloc(length);
memcpy(s2, s1, length);
~~~

Note that I used memcpy instead of strcpy.
Since we already have the length of the string, this also avoids the loop in strcpy which would be required to find the end of the string.
These kind of optimizations may seem like splitting hairs, but they can make a big difference in the overall runtime of your code.
For example, with the optimization shown above, I was able to reduce the runtime of a particular loop by around 15%.

Know of any other common functions with performance problems people may not be aware of? Share your inside info in the comments!

Aside: While researching the performance of strlen, I came across this interesting forum post which provides an efficient strlen implementation from Knuth.

## Update: June 14, 2012

GCC 4.7.1 has an optimization to address this very issue. See the snippet below from the release notes.

> A string length optimization pass has been added…The pass can e.g. optimize
>
> ~~~ c
> char *bar (const char *a)
> {
>   size_t l = strlen (a) + 2;
>   char *p = malloc (l); if (p == NULL) return p;
>   strcpy (p, a); strcat (p, "/"); return p;
> }
> ~~~
>
> into:
>
> ~~~ c
> char *bar (const char *a)
> {
>   size_t tmp = strlen (a);
>   char *p = malloc (tmp + 2); if (p == NULL) return p;
>   memcpy (p, a, tmp); memcpy (p + tmp, "/", 2); return p;
> }
> ~~~
