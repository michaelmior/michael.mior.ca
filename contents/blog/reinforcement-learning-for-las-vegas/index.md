---
title: Reinforcement learning for Las Vegas
author: michaelmior
date: 2018-02-04
template: article.jade
summary: "A walkthrough of an implementation of deep reinforcement learning for the dice game Las Vegas."
image: dice.png
---

During a department board games night, we were playing [Las Vegas](https://boardgamegeek.com/boardgame/117959/las-vegas) when a fellow player remarked that he wondered how an AI for the game would perform.
Since I had been meaning to spend some time learning to implement neural network techniques, this seemed like a great opportunity.
One of the first things that came to mind was a [paper](https://arxiv.org/abs/1312.5602) from the DeepMind team on using deep neural networks to implement a variant [Q-learning](https://en.wikipedia.org/wiki/Q-learning).
The gist behind classical Q-learning is maintaining a table with the expected utility of a particular action in a given state.
This table is updated while the game is played based on the observed rewards.

The idea behind deep Q-learning is to use a neural network to replace the table which is traditionally used.
One of the big advantages is that it's possible to handle much larger state-action spaces using a neural network.
The first step was to decide how to represent the game state.
For anyone not familiar with Las Vegas, [Yucata](http://www.yucata.de/en/Rules/LasVegas) has a good overview of the rules and a mechanism for playing online.
The short version is that players take turns rolling dice and placing them on differently numbered casinos in an attempt to get the highest cash reward.

I first built a simple class structure for the game in Python to represent all the game state and stubbed out a couple functions to implement the game logic.
The next step was to decide how the state was going to fed into the network.
In the original deep Q-learning paper, the authors used a [convolutional neural network](https://en.wikipedia.org/wiki/Convolutional_neural_network) to feed in frames from gameplay video.
I instead chose to explicit represent the state using the following values:
* Number of players in the game
* Current game round number
* Cash currently held by each player
* Number of dice currently on each casino
* Money available at each casino
* Number of dice of each value in the current roll

Explicitly representing the state also resulted in a different structure for the network itself.
The input layer simply received a normalized vector of the state values above.
The second fully-connected layer was simply half the size of the first layer.
Both of the first two layers used a [ReLU](https://en.wikipedia.org/wiki/Rectifier_(neural_networks)) activation function.
The final output layer was also fully connected but with a linear activation function and a size of six to represent the choice of each possible die.
After training the AI against 4 random opponents, the AI was able to win around 50% of games which I was pretty happy with given the inherent randomness of the game.
However, the evaluation was by no means robust and something that definitely needs to be improved upon.

I later implemented hyperparameter optimization using the [Hyperopt](https://github.com/hyperopt/hyperopt) library.
After much more training, I tried to optimize the reward values, [discount factor](https://en.wikipedia.org/wiki/Q-learning#Discount_factor)), and other parameters specific to deep Q-learning.
This led me to change the kernel initializer to [LeCun uniform](https://keras.io/initializers/#lecun_uniform), the activation function of the first two layers to a [sigmoid function](https://keras.io/activations/#sigmoid), and the optimization algorithm from [RMSprop](https://keras.io/optimizers/#rmsprop) to [Adam](https://keras.io/optimizers/#adam).
This was mostly for a bit more fun although it did seem to provide about a 20% performance improvement on some simple evaluations I tried.

Since this is just a fun side project, one of the next things on my agenda is to implement a UI using [boardgame.io](http://boardgame.io/) so I can get a sense of how the AI "feels."
All in all, this was a pretty fun project.
The source code is available [on GitHub](https://github.com/michaelmior/lasvegas) for anyone who wants to play with it.
