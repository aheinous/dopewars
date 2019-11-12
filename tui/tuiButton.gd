extends Button

func _ready():
	connect("draw", tui_manager, "onNeedRedraw") 

func tuiDraw(overlay):
	print("tuiDraw()")
	var olay = tui_manager.overlay
	olay.registerString(self, olay.boxString(rect_size, text))

