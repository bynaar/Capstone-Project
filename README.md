# Capstone-Project
Last modified, May 2016.

This project is a population simulator made in the Godot Game Engine.

When the simulator starts, it will generate a large map of tiles with a randomly generated geography for each tile. Each tile of a certain geiography map has a certain food and difficulty value. Populations will consume the food, but the difficulty will increase the food consumption on the tile. Thus populations living on the tile are limited if they offer less food, and cnnot clonize the tile if it is too difficult to live there.

Populations over time will begin to build larger cities based on the number of surrounding tiles of the same or lower city type. There are four city types in this simulation: Villages, Towns, Cities, and Citadels. Villages surrounded by four or more city types, will upgrade to a Town, asusming there is enough food on the tile to support a Town. If a forest tile supplies 3 food and has 3 difficulty, it cannot upgrade, because the Town living on the space, already consumes all the available food on the space.

If a Town, is surrounded by four or more Towns or city tiles of a superior type, it will upgrade to a City. And the same is for Citadels. A city surrounded by four cities or citadels will become a Citadel, though it will require 3 more food than difficulty. 

More details are in the REVIE CAPSTONE FINAL PAPER pdf file in the project.
