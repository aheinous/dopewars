extends Control

signal value_changed



var value : int = 0
var max_value : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	TUI.registerElement(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func tuiDraw(tui):
	tui.drawToTUI(self, tui.boxString(rect_size, String(value)))
