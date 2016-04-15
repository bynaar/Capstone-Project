
extends Node2D

var tiles
var mapHeight
var mapLength

var tileManager

var tileXML = preload("res://Assets/objects/obj_tile_base.xml")
var mapGeneratorXML = preload("res://Assets/objects/obj_map_generator.xml")

func _ready():
	tiles = []

func createTileMap(_height, _length):
	mapHeight = _height
	mapLength = _length
	generateTileMap()
	generateGeographyMap()
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

func updateAllTiles():
	for row in tiles:
		for tile in row:
			tile.updateTile()

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
	var total = forests + grasslands + deserts + tundras
	return [total, forests, grasslands, deserts, tundras]

func generateGeographyMap():
	randomize()
	var mapGenerator = mapGeneratorXML.instance()
	for row in tiles:
		for tile in row:
			mapGenerator.generateGeographyTile(tile, mapHeight)

func startingColonizedTile():
	tiles[mapHeight/2][mapLength/2].colonize()