---
title: Game of Firsts
author: michaelmior
date: 2024-08-07
template: article.pug
summary: "A simple word game built with AI."
image: puzzle.png
---

A lot of things seem to serve to unintentionally [nerd snipe](https://xkcd.com/356/) me.
Over the weekend, a friend introduced me to [The Initials Game](https://www.initialsgame.com/).
The gist of it is that you are given two letters and a series of clues.
The goal is to guess a two-word phrase that starts with the given letters.
It's a pretty entertaining game and I wondered how easy it would be to generate such puzzles.

The next day I was able to hack something together in a couple hours that actually worked reasonably well.
The entire thing is based around [Ollama](https://ollama.com/) since I wanted to be able to run locally.
I started off with a system prompt

```
You are a puzzle designer who is going to help create a word puzzle. Any pieces of the puzzle you generate should be short and simple and easily understandable to the average English-speaking adult anywhere in the world.
```

Then I split the remainder into two prompts.
Given two letters, the first prompt asks for a phrase to be used in the puzzle.

```
I will give you two letters and then you will think of a very simple two word phrase that starts with those two letters. For example, if I give you the letters C and F, you might pick Correctional Facility. For the letters P and T, you might select Party Trick. Respond with only the two word phrase and nothing else. The letters are {letter1} and {letter2}.
```

The second prompt asks for clues given this phrase.

```
I am going to give you a two word phrase and I would like you to devise five very short clues (three or four words maximum) that will help someone guess the phrase. The first clue should be very vague and subsequent clues should get increasingly specific. Do not use any of the words from the phrase anywhere in any of the clues or elsewhere in your response. Output should be a simple numbered list in Markdown format. The two word phrase is "{phrase}".
```

I later made a few further tweaks to these prompts, but this is the gist of it.
At this point, I was sometimes getting some reasonable phrases, but sometimes phrases that didn't make sense at all.
Sometimes the letters in the phrase didn't match the letters that were asked for.
But the biggest problem was that sometimes the phrases generated were pretty nonsensical, for example, "Bird Age."
To solve this, I ended up using [NGRAMS](https://ngrams.dev/) which is a REST API for querying the Google Books n-gram dataset.
This allows easily checking for how common the phrase is.
For example, "Bird Age", appears only 269 times, while the much more reasonable phrase "Business Association" appears 200,334 times.
The solution was to generate multiple phrases until one meets an arbitrarily-determined threshold of popularity.

Up until this point, I was just printing all the puzzles out via text.
But it's a bit more fun to have them read out.
I ended up using [OpenTTS](https://github.com/synesthesiam/opentts) to generate audio from the puzzles.
One unexpected problem is that coqui-tts, the actually speech system used, seems to have a real problem pronouncing letters when just written out as single letters.
For example, here's what I got when I tried to have it say "The letters are E and A."

<audio controls src="ae.wav"></audio>

To solve this, I wrote out phonetic spellings of each letter, tweaking until each one sounded right.
If I instead generate audio for "The letters are Eeh and Ae," I get the following much more reasonable output.

<audio controls src="ae2.wav"></audio>

I first started with requiring the user to specify which letters to generate.
When switching to randomly picking letters, a uniform distribution doesn't really work well.
English words aren't randomly distributed so it makes sense to match this frequency.
To do this, I instead pick letters randomly but weighted based on the frequency of the first letters of English words.
To avoid picking a lot of double letters, I also halve the probability of the first letter when generating the second letter.

Finally, here's an example of a complete puzzle.
The code is available [on GitHub](https://github.com/michaelmior/game-of-firsts).
Not sure if I'll keep working on this project further, but it's pretty impressive what you can quickly accomplish these days with a bit of use of AI.

<audio controls src="puzzle.wav"></audio>
