extends "res://tui/tuiElement.gd"
func _ready():
	connect("resized", self, "_onResized")
	
	
func _onResized():
	setCharSize((rect_size / TUI.cSize).floor())
	
	
func _onRefresh():
	for child in get_children():
		if child.has_method("getCharSize"):
			child.charPos = (charSize/2  - child.charSize/2).round()
