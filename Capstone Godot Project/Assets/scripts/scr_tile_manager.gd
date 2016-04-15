
extends Node2D

var tileMapXML = preload("res://Assets/objects/obj_tile_map.xml")
var tileMap
var occupiedTileMap
var cameraObject
var userInterface

var mapHeight
var mapLength

var timeTotal = 0
var updateTick = 1 #This determines how often update is called
var updateTileState = false

var timer

func _ready():
	print ("start")
	mapHeight = 52
	mapLength = 80
	tileMap = tileMapXML.instance()
	add_child(tileMap)
	generateTileMap()
	
	cameraObject = get_parent().get_node("Camera2D")
	cameraObject.tileManager = self
	
	userInterface = get_parent().get_node("UI")
	userInterface.tileManager = self
	updateTileState = true
	
	timer = get_node("Timer")
	timer.set_timer_process_mode(timer.TIMER_PROCESS_FIXED)
	timer.set_one_shot(false)
	timer.set_wait_time(updateTick)
	timer.start()
	centerCamera()
	print ("done")

func updateAllTiles():
	tileMap.updateAllTiles()

func generateTileMap():
	tileMap.createTileMap(mapHeight, mapLength)
	print("linked map to manager")

func _on_Timer_timeout():
	timeTotal += 1
	userInterface.updateTime(timeTotal)
	if (updateTileState):
		updateAllTiles()
		getColonizedList()

func getColonizedList():
	var colonizedList = tileMap.getNumberOfColonizedTiles()
	userInterface.updateColonizedText(colonizedList)

func centerCamera():
	cameraObject.set_pos(tileMap.tiles[tileMap.mapHeight/2][tileMap.mapLength/2].get_pos())

func changeTimeStep(_step):
	updateTick = _step
	timer.set_wait_time(updateTick)