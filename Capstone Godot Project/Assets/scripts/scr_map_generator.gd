
extends Node2D

var geographyXML = preload("res://Assets/objects/obj_tile_geography.xml")

func _ready():
	pass

func generateGeographyTile(_tile, _mapHeight): #this applies a forest geography to any tile it's called on
	var tempGeography = geographyXML.instance()
	var randomNumber = rand_range(0,4)
	if randomNumber < 1.5:
		tempGeography.setGeography("Water")
	elif randomNumber < 2:
		tempGeography.setGeography("Desert")
	elif randomNumber < 3:
		tempGeography.setGeography("Forest")
	else:
		tempGeography.setGeography("Grassland")
	if ((_tile.y > ((_mapHeight * 7) / 8) or _tile.y < (_mapHeight / 8))):
		randomNumber = rand_range(0,2)
		if randomNumber < 1:
			 tempGeography.setGeography("Tundra")
	_tile.applyGeography(tempGeography)