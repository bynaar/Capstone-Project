
extends Node2D

var food
var difficulty
var type = ""
var tileImage
var resourceModifierImage
var geographyModifierImage
var resourceModifier
var geographyModifier
var geographyData = "res://Assets/data/data_geography.txt"

#Forest = 1, Food = 3, Difficulty = 3
func _ready():
	pass

func setGeography(geographyType):
	var geographyFile = File.new()
	geographyFile.open(geographyData, File.READ)
	if geographyFile.is_open():
		while geographyFile.eof_reached() == false:
			var geoLine = geographyFile.get_line()
			geoLine = geoLine.split(",")
			if geoLine[0] == geographyType:
				setType(str(geoLine[0]))
				setFood(int(geoLine[1]))
				setDifficulty(int(geoLine[2]))
				setTileImage(geoLine[3])
				break

func applyModifiers():
	pass

func setType(_type):
	type = _type

func setFood(_food):
	food = _food

func setDifficulty(_difficulty):
	difficulty = _difficulty

func setTileImage(_tileImage):
	tileImage = _tileImage