
extends Camera2D

var cameraPosition = self.get_pos()
var isPressed
var updateButton
var autoUpdateButton
var totalTime
var tileManager

var cameraSpeed = 10

func _ready():
	set_process_input(true)
	isPressed = false

func _input(event):
	#Moving the camera
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_WHEEL_DOWN:
			var zoom = Vector2(self.get_zoom().x + .1, self.get_zoom().y + .1)
			if zoom.x > 10:
				zoom.x = 10
			if zoom.y > 10:
				zoom.y = 10
			self.set_zoom(Vector2(zoom.x, zoom.y))
		if event.button_index == BUTTON_WHEEL_UP:
			var zoom = Vector2(self.get_zoom().x - .1, self.get_zoom().y - .1)
			if zoom.x < 2:
				zoom.x = 2
			if zoom.y < 2:
				zoom.y = 2
			self.set_zoom(Vector2(zoom.x, zoom.y))
		if Input.is_mouse_button_pressed(1) and isPressed == false:
			isPressed = true
			cameraPosition = self.get_offset() + event.pos
		if !Input.is_mouse_button_pressed(1) and isPressed == true:
			isPressed = false
	if event.type == InputEvent.MOUSE_MOTION and isPressed:
		self.set_offset(cameraPosition - event.pos)
	
	if event.type == Input.is_action_pressed("Camera Up"):
		self.set_offset(self.get_offset() + Vector2(0,-cameraSpeed))