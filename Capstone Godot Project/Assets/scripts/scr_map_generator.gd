
extends Node2D

var geographyXML = preload("res://Assets/objects/obj_tile_geography.xml")

func _ready():
	pass

func generateGeographyTile(_tile, _mapHeight): #this applies a forest geography to any tile it's called on
	var tempGeography = geographyXML.instance()
	var randomNumber = rand_range(0,4)
	if randomNumber < 1:
		tempGeography.setGeography("Water")
#	elif randomNumber < 1.5:
#		tempGeography.setGeography("Desert")
	elif randomNumber < 2.25:
		tempGeography.setGeography("Forest")
	else:
		tempGeography.setGeography("Grassland")
	if (canBeTundraOrDesert(randomNumber) and (_tile.y > ((_mapHeight * 7) / 8) or _tile.y < (_mapHeight / 8))):
		randomNumber = rand_range(0,2)
		if randomNumber < 1.7:
			 tempGeography.setGeography("Tundra")
	if (canBeTundraOrDesert(randomNumber) and (_tile.y > ((_mapHeight * 4) / 14) and _tile.y < ((_mapHeight * 11)/ 14))):
		randomNumber = rand_range(0,2)
		if randomNumber < 1.2:
			 tempGeography.setGeography("Desert")
	_tile.applyGeography(tempGeography)

func canBeTundraOrDesert(randomNumber):
	if randomNumber < 2.25:
		return false
	else: return true

