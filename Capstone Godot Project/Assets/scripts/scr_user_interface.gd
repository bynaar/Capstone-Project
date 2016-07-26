extends CanvasLayer

var tileManager

var timeStepButton
var timeText
var colonizedText

func _ready():
	timeStepButton = get_node("Time Step Button")
	timeText = get_node("Info/Total Time")
	colonizedText = get_node("Info/Colonized Tile Numbers")
	
	timeStepButton.add_item("1.0", 0)
	timeStepButton.add_item("0.5", 1)
	timeStepButton.add_item("0.1", 2)

func _on_Update_Tile_Button_pressed():
	tileManager.updateAllTiles()
	print("Update")

func _on_Auto_Update_Button_pressed():
	tileManager.updateTileState = true
	print("Auto Update On")

func updateTime(_totalTime):
	timeText.clear()
	var displayText = "Time: " + str(_totalTime)
	timeText.add_text(displayText)

func updateColonizedText(_list):
	colonizedText.clear()
	colonizedText.add_text("Total: " + str(_list[0]))
	colonizedText.newline()
	colonizedText.newline()
	colonizedText.add_text("Forest: " + str(_list[1]))
	colonizedText.newline()
	colonizedText.add_text("Grassland: " + str(_list[2]))
	colonizedText.newline()
	colonizedText.add_text("Desert: " + str(_list[3]))
	colonizedText.newline()
	colonizedText.add_text("Tundra: " + str(_list[4]))
	colonizedText.newline()
	colonizedText.newline()
	colonizedText.add_text("Villages: " + str(_list[5]))
	colonizedText.newline()
	colonizedText.add_text("Towns: " + str(_list[6]))
	colonizedText.newline()
	colonizedText.add_text("Cities: " + str(_list[7]))
	colonizedText.newline()
	colonizedText.add_text("Citadels: " + str(_list[8]))
	

func _on_Time_Step_Button_item_selected( ID ):
	if ID == 0:
		tileManager.changeTimeStep(1)
	if ID == 1:
		tileManager.changeTimeStep(0.5)
	if ID == 2:
		tileManager.changeTimeStep(0.1)
