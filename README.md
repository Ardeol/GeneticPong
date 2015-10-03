# GeneticPong
It will become the first conscious AI.

It's the classic pong game! So… what's so interesting about it? In this version of pong, the computer starts off with no knowledge of the game and tries to learn how to play over time. By playing against your computer, you can actually train it to become better and better at pong.



Pong is a tennis-like game where players control paddles on each side of the board and hit a ball back and forth. If your opponent misses the ball, you score a point.

This is more of a simulation than it is a game, though. The goal of the project was to apply the theory behind genetic algorithms to a simple game such as pong, and as such there is no score limit or win condition. Instead, you select what kind of player will play on each side of the board, from the following choices:

    Human: A human player. The left player uses WASD for movement, and the right player uses the arrow keys. So yes, you can have a friendly 2-player match if you'd like.
    Basic AI: An easy AI that follows the y-position of the ball.
    Perfect AI: A much better version of the AI that actually does math to predict where the ball will go.
    Genetic AI: The AI that you want to train. It starts off knowing nothing except for the fact that scoring is good. This option is not set to actually learn; it instead uses its best current strategy.
    Trainer: This is what you use to actually train the Genetic AI. The AI will try out various strategies and in time hone down what it thinks is best.

So how do you train the AI? Simply set one side or the other to Trainer mode! My recommendation is to set one side to Trainer and the other side to Perfect AI and let it run for a couple of hours as you do other things. Then after that time period is up, try playing Human verses Genetic AI to see how good it has gotten!

Some notes:

    To get out of the game state, hit the Esc button; this brings you back to the menu
    The left and right AIs are treated separately and will develop different strategies. After they've been trained for a while, try pitting them against each other!
    Your AI will probably never become very godlike at the game, as this is only a basic genetic algorithm. However, you'll be surprised at how well it can learn when starting from nothing.
    You can reset the AI at any time using the Reset Genetic button if you feel your AI has adopted a poor strategy.

This project was made using HaxeFlixel and the Haxe programming language.
