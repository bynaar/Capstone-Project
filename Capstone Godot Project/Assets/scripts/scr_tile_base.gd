
extends Sprite

var geographyOfTile
var food
var difficulty

var colonizeCounterText

var x
var y

var mapHeight
var mapLength

var occupied = false
var cityType = "Village"
var cityTypeImage
var townOverlay = preload("res://Assets/sprites/spr_tile_town_overlay.png")
var cityOverlay = preload("res://Assets/sprites/spr_tile_city_overlay.png")
var citadelOverlay = preload("res://Assets/sprites/spr_tile_citadel_overlay.png")

var nearbyTiles = [] #tiles within 3 spaces
var borderingTiles = [] #tiles next this tile
var excessFood
var foodRecieved
var numberOfBorderingOccupiedTiles
var colonizeCounter = 0
var hungerMeter = 0

var inhabitedSprite
var inhabitedSpriteXML = preload("res://Assets/objects/obj_inhabited_status.xml")
var textureInahbited_0 = preload("res://Assets/sprites/spr_tile_inhabited_countdown_0.png")
var textureInahbited_1 = preload("res://Assets/sprites/spr_tile_inhabited_countdown_1.png")
var textureInahbited_2 = preload("res://Assets/sprites/spr_tile_inhabited_countdown_2.png")
var textureInahbited_3 = preload("res://Assets/sprites/spr_tile_inhabited_countdown_3.png")
var textureInahbited_4 = preload("res://Assets/sprites/spr_tile_inhabited_countdown_4.png")
var textureInahbited_5 = preload("res://Assets/sprites/spr_tile_inhabited_countdown_5.png")
var textureInahbited_6 = preload("res://Assets/sprites/spr_tile_inhabited_countdown_6.png")



var tileMap

func _ready():
	cityTypeImage = self.get_node("Type Overlay Image")

func updateTile():
	if (occupied):
		updateBorderingTiles()
		hungerUpdate()
#		if (canRedistributeFood()):
#			redistributeFood("excess")
#			pass
		if (canColonize()):
			colonizeTargetTile(chooseTileToColonize(getListOfColonizableTiles()), "Population")
#		print("Tile: ", x, " ", y) 
#		print("Hunger: ", hungerMeter)
#		print("Colonize: ", colonizeCounter)

func applyGeography(_geography):
	geographyOfTile = _geography.type
	food = _geography.food
	difficulty = _geography.difficulty
	self.set_texture(load(_geography.tileImage))

func isOccupied():
	return occupied

func getCityType():
	return cityType

func updateFood():
	for tile in borderingTiles:
		if tile.geographyOfTile.type == "Water":
			food += 1

##########################################################################################
#HUNGER

func hungerUpdate():
	if (hungerMeter == 2):
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
		colonizeTargetTile(chooseTileToColonize(getListOfColonizableTiles()), "Hunger")
		removeOccupiedStatus()

func canMoveToNearbyTile():
	if getListOfColonizableTiles().size() > 0:
		return true
	else: 
		return false

##########################################################################################
#COLONIZATION METHODS

func colonize(_isHungry, _hunger):
	occupied = true
	loadInhabitedStatus()
	if _isHungry:
		if (food - difficulty > 0):
			hungerMeter = 0
		else:
			hungerMeter = _hunger + 1

func canColonize():
	if (hungerMeter <= 0):
		if (colonizeCounter < 12):
			colonizeCounter += 1 + (food - difficulty)
			updateInhabitedImage()
			return false
		if (colonizeCounter >= 12):
			return true
	return false

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

func colonizeTargetTile(_tile, _type):
	if (_tile == null):
		return
	_tile.colonize(false, 0)
	colonizeCounter = 0
	updateInhabitedImage()
	if _type == "Hunger":
		_tile.colonize(true, hungerMeter)
		removeOccupiedStatus()
	elif _type == "Explore":
		pass


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
#CIVILIZATION TOWN/CITY SYSTEM

func architecturalReevaluation():
	if isOccupied():
		var occupiedSurroundingVillages = 0
		var occupiedSurroundingTowns = 0
		var occupiedSurroundingCities = 0
		for tile in borderingTiles:
			if tile.isOccupied():
				occupiedSurroundingVillages += 1
				if tile.getCityType() == "Town" or tile.getCityType() == "City" or tile.getCityType() == "Citadel":
					occupiedSurroundingTowns += 1
				if tile.getCityType() == "City" or tile.getCityType() == "Citadel": 
					occupiedSurroundingCities += 1
		if occupiedSurroundingCities >= 6:
			self.cityType = "Citadel"
		elif occupiedSurroundingTowns >= 4:
			self.cityType = "City"
		elif occupiedSurroundingVillages >= 4:
			self.cityType = "Town"
		updateCityTypeImage()

##########################################################################################
#OCCUPATION STATUS REMOVAL

func removeOccupiedStatus(): #for hunger, removes all food it is recieving from other tiles
	occupied = false
	hungerMeter = 0
	colonizeCounter = 0
	self.remove_child(inhabitedSprite)

##########################################################################################
#DISPLAY METHODS
#DISPLAYS THE IMAGES ON THE TILE

func updateInhabitedImage():
	if colonizeCounter == 0 or colonizeCounter == 1:
		inhabitedSprite.set_texture(textureInahbited_0)
	elif colonizeCounter == 2 or colonizeCounter == 3:
		inhabitedSprite.set_texture(textureInahbited_1)
	elif colonizeCounter == 4 or colonizeCounter == 5:
		inhabitedSprite.set_texture(textureInahbited_2)
	elif colonizeCounter == 6 or colonizeCounter == 7:
		inhabitedSprite.set_texture(textureInahbited_3)
	elif colonizeCounter == 8 or colonizeCounter == 9:
		inhabitedSprite.set_texture(textureInahbited_4)
	elif colonizeCounter == 10 or colonizeCounter == 11:
		inhabitedSprite.set_texture(textureInahbited_5)
	else:
		inhabitedSprite.set_texture(textureInahbited_6)

func loadInhabitedStatus():
	inhabitedSprite = inhabitedSpriteXML.instance()
	self.add_child(inhabitedSprite)

func updateCityTypeImage():
	if cityType == "Citadel":
		self.cityTypeImage.set_texture(citadelOverlay)
	elif cityType == "City":
		self.cityTypeImage.set_texture(cityOverlay)
	elif cityType == "Town":
		self.cityTypeImage.set_texture(townOverlay)

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