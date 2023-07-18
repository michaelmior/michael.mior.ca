---
title: LLMs for Schema Augmentation
author: michaelmior
date: 2023-07-18
template: article.jade
summary: "Large language models can be exploited to automatically augment JSON Schemas with useful information."
image: chatgpt.jpg
---

I have recently been experimenting with the use of large language models (LLMs) to augment JSON Schemas with useful features.
While ChatGPT gets most of the press, there are many other LLMs that are specifically designed to work with code.
The idea is that these LLMs can be used to augment incomplete schemas with additional useful information.

Consider an example schema such as the one below.
This is a basic schema which might be created from an automated schema mining process.
For such a small schema, this is probably sufficient information to tell you useful things about the dataset.

~~~ json
{
  "type": "object",
  "properties": {
    "name": {"type": "string"},
    "address": {"type": "string"}
  }
}
~~~

However, as schemas grow in size and complexity, additional metadata can be useful.
For example, JSON Schemas can contain a `description` attribute which provides a natural language description of each property.
To generate a value for such a property, we can prompt the LLM with a prefix of the schema such as the following.

~~~ json
{
  "type": "object",
  "properties": {
    "name": {"type": "string"},
    "address": {"type": "string", "description": "
~~~

From here, we just need to continue generating tokens until we get to a closing quote.
This approach was borrowed from [Jsonformer](https://github.com/1rgs/jsonformer) which uses a similar approach to induce LLMs to generate structured output.
Continuing to do so for each property using [Replit's code LLM](https://huggingface.co/replit/replit-code-v1-3b) gives the following output:

~~~ json
{
  "type": "object",
  "properties": {
    "name": {
      "type": "string",
      "description": "The name of the item"
    },
    "address": {
      "type": "string",
      "description": "The address of the person"
    }
  }
}
~~~

While it's not perfect, and not obviously useful for such a small schema, I think the results are promising.
I've also tried several other schema formats such as [Zod](https://github.com/colinhacks/zod), [Typescript object types](https://www.typescriptlang.org/docs/handbook/2/objects.html), and [Pydantic](https://docs.pydantic.dev/latest/).
A lot more experimentation is required with these different formats and various LLMs to see which works best.
So far, I'm pretty pleased with results.
The code for this post [is available on GitHub](https://github.com/michaelmior/annotate-schema).
