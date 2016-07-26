
extends Node2D

var tiles
var mapHeight
var mapLength

var tileManager

var tileXML = preload("res://Assets/objects/obj_tile_base.xml")
var mapGeneratorXML = preload("res://Assets/objects/obj_map_generator.xml")

const cityLevel = {"village":0,"town":1,"city":2,"citadel":3}

func _ready():
	tiles = []

func createTileMap(_height, _length):
	mapHeight = _height
	mapLength = _length
	generateTileMap()
	generateGeographyMap()
	updateTileWaterFood()
	print("tiles generated")
	startingColonizedTile()

func generateTileMap():
	tiles.resize(mapHeight)
	for a in range(0,mapHeight):
		tiles[a] = []
		tiles[a].resize(mapLength)
		for b in range (0,mapLength):
			tiles[a][b] = tileXML.instance()
			self.add_child(tiles[a][b])
			tiles[a][b].tileMap = self
			tiles[a][b].mapHeight = mapHeight
			tiles[a][b].mapLength = mapLength
			tiles[a][b].set_pos(Vector2(608 * b + 304 * (a%2), 174 * a))
			tiles[a][b].x = b
			tiles[a][b].y = a

func updateTileWaterFood(): #If a tile is bordering water, it will increase its base food value by 1 for each water tile bordering it
	for row in tiles:
		for tile in row:
			tile.updateBaseFood()

func updateAllTiles():
	for row in tiles:
		for tile in row:
			tile.updateTile()
	for row in tiles:
		for tile in row:
			tile.architecturalReevaluation()

func getNumberOfColonizedTiles():
	var forests = 0
	var grasslands = 0
	var deserts = 0
	var tundras = 0
	for row in tiles:
		for tile in row:
			if tile.isOccupied():
				if tile.geographyOfTile == "Forest":
					forests += 1
				if tile.geographyOfTile == "Grassland":
					grasslands += 1
				if tile.geographyOfTile == "Desert":
					deserts += 1
				if tile.geographyOfTile == "Tundra":
					tundras += 1
	var villages = 0
	var towns = 0
	var cities = 0
	var citadels = 0
	for row in tiles:
		for tile in row:
			if tile.isOccupied():
				if tile.cityType == cityLevel.village:
					villages += 1
				if tile.cityType == cityLevel.town:
					towns += 1
				if tile.cityType == cityLevel.city:
					cities += 1
				if tile.cityType == cityLevel.citadel:
					citadels += 1
	var total = forests + grasslands + deserts + tundras
	return [total, forests, grasslands, deserts, tundras, villages, towns, cities, citadels]

func generateGeographyMap():
	randomize()
	var mapGenerator = mapGeneratorXML.instance()
	for row in tiles:
		for tile in row:
			mapGenerator.generateGeographyTile(tile, mapHeight)
			tile.updateTotalFood()

func startingColonizedTile():
	tiles[mapHeight/2][mapLength/2].colonize(false, 0)