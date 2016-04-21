
extends Sprite

var geographyOfTile
var food
var difficulty

var difficultyText
var foodText

var x
var y

var mapHeight
var mapLength

var occupied = false
var nearbyTiles = [] #tiles within 3 spaces
var borderingTiles = [] #tiles next this tile
var excessFood
var foodRecieved
var numberOfBorderingOccupiedTiles
var colonizeCounter = 0
var hungerMeter = 0
var inhabitedSprite
var inhabitedSpriteXML = preload("res://Assets/objects/obj_inhabited_status.xml")

var tileMap


func _ready():
	difficultyText = self.get_child(2)
	foodText = self.get_child(3)
	pass

func updateTile():
	if (occupied):
		hungerUpdate()
#		if (canRedistributeFood()):
#			redistributeFood("excess")
#			pass
		if (canColonize()):
			colonizeTargetTile(chooseTileToColonize(getListOfColonizableTiles()))
#		print("Tile: ", x, " ", y) 
#		print("Hunger: ", hungerMeter)
#		print("Colonize: ", colonizeCounter)

func applyGeography(_geography):
	geographyOfTile = _geography.type
	food = _geography.food
	difficulty = _geography.difficulty
	self.set_texture(load(_geography.tileImage))
	updateDisplayNumbers()

func isOccupied():
	return occupied

##########################################################################################
#HUNGER

func hungerUpdate():
	if (hungerMeter == 2 or hungerMeter == 4):
		hungerMovement()
	if (hungerMeter >= 4):
		removeOccupiedStatus()
		pass
	elif (food < difficulty):
	#	if (len(excessFood) > 0):
	#		redistributeFood("hunger")
		hungerMeter += 1
	elif (hungerMeter > 0):
		hungerMeter -= 1

##########################################################################################
#TILE MOVEMENT DUE TO HUNGER

func hungerMovement():
	if canMoveToNearbyTile():
		colonizeTargetViaHunger(chooseTileToColonize(getListOfColonizableTiles()))

func canMoveToNearbyTile():
	updateBorderingTiles()
	if getListOfColonizableTiles().size() > 0:
		return true
	else: 
		return false

##########################################################################################
#COLONIZATION METHODS

func colonize():
	occupied = true
	loadInhabitedStatus()

func canColonize():
	if (hungerMeter <= 0):
		if (colonizeCounter < 10):
			colonizeCounter += 1 + (food - difficulty)
			return false
		if (colonizeCounter >= 10):
			updateBorderingTiles()
			return true

func updateBorderingTiles():
	var tiles = tileMap.tiles
	borderingTiles = []
	var locationModifier = y%2
	#The location modifier determines where the tile will search to find colonizable tiles
	if (y + 2 <= mapHeight - 1):
		borderingTiles.append(tiles[y+2][x])
	if (y - 2 >= 0):
		borderingTiles.append(tiles[y-2][x])
	if (y + 1 <= mapHeight - 1 and x - 1 + locationModifier >= 0):
		borderingTiles.append(tiles[y+1][x-1 + locationModifier])
	if (y + 1 <= mapHeight - 1 and x + locationModifier <= mapLength - 1):
		borderingTiles.append(tiles[y+1][x + locationModifier])
	if (y - 1 >= 0 and x - 1 + locationModifier >= 0):
		borderingTiles.append(tiles[y-1][x-1 + locationModifier])
	if (y - 1 >= 0 and x + locationModifier <= mapLength - 1):
		borderingTiles.append(tiles[y-1][x + locationModifier])

func getListOfExploredTiles():
	pass

func getListOfColonizableTiles():
	var colonizableTiles = []
	for tile in borderingTiles:
		if (tile.food >= tile.difficulty and tile.occupied == false):
			colonizableTiles.append(tile)
	return colonizableTiles

func chooseTileToColonize(_colonizableTiles):
	if (_colonizableTiles.size() == 0):
		return null
	var tileToColonize = _colonizableTiles[0]
	var similarColonizableTiles = []
	similarColonizableTiles.append(tileToColonize)
	#similar tiles will now only colonize in a random direction
	#later implement to move towards more fertile areas
	_colonizableTiles.remove(0)
	for tile in _colonizableTiles:
		if (tile.food - tile.difficulty) > (tileToColonize.food - tileToColonize.difficulty):
			tileToColonize = tile
			similarColonizableTiles.clear()
			similarColonizableTiles.append(tileToColonize)
		elif (tile.food - tile.difficulty) == (tileToColonize.food - tileToColonize.difficulty):
			similarColonizableTiles.append(tile)
	if (similarColonizableTiles.size() > 1): #returns a random tile in the list of same tiles
		return similarColonizableTiles[rand_range(0,similarColonizableTiles.size())]
	else:
		return tileToColonize

func colonizeTargetTile(_tile):
	if (_tile == null):
		return
	_tile.colonize()
	colonizeCounter = 0

##########################################################################################
#CONDITION SPECIFIC COLONIZATION
#VIA HUNGER MOVEMENT OR TILE EXPLORATION

func colonizeViaExplore(_tile):
	pass

func colonizeTargetViaHunger(_tile):
	if (_tile == null):
		return
	_tile.colonizeViaHunger(hungerMeter)
	removeOccupiedStatus()

func colonizeViaHunger(_hungerMeter):
	occupied = true
	loadInhabitedStatus()
	if (food - difficulty > 0):
		hungerMeter = 0
	else:
		hungerMeter = _hungerMeter
	colonizeCounter = 0

##########################################################################################
#EXPLORATION METHODS
#IMPLEMENT LATER

func exploreSurrroundingTile():
	pass

func canExplore():
	updateBorderingTiles()
	if (getListOfColonizableTiles().size() == 0):
		
		pass
	pass

func chooseTileToExplore():
	pass

func exploreToTile(_tile):
	pass

func updateListOfNearbyOccupiedTiles():
	var tiles = []
	
	#insert working code
	nearbyTiles = tiles

##########################################################################################
#OCCUPATION STATUS REMOVAL

func removeOccupiedStatus(): #for hunger, removes all food it is recieving from other tiles
	occupied = false
	numberOfBorderingOccupiedTiles = 0
	hungerMeter = 0
	colonizeCounter = 0
	self.remove_child(self.get_child(4))

##########################################################################################
#DISPLAY METHODS
#DISPLAYS THE NUMBERS AND IMAGES ON THE TILE

func updateDisplayNumbers():
	difficultyText.add_text(str(difficulty))
	foodText.add_text(str(food))
	pass

func loadInhabitedStatus():
	inhabitedSprite = inhabitedSpriteXML.instance()
	self.add_child(inhabitedSprite)

###########################################################################################
#FOOD DISTRIBUTION METHODS
#LEAVE OUT UNTIL FURTHER IN PROJECT

#func canRedistributeFood():
#	if (food > difficulty and (len(excessFood) < food - difficulty)):
#		return true

#func transferExcessFoodToNearbyTiles(listOfTiles):
#	pass

#func redistributeFood(input):
#	if input == "excess":
#		transferExcessFoodToNearbyTiles(updateListOfNearbyOccupiedTiles())
#		pass
#	elif input == "hunger":
#		for tile in excessFood:
#			tile.foodRecieved.remove(self)



