extends Button



onready var tuiOverlay = $"../../../TUI_Overlay"

func _ready():
	pass # Replace with function body.
	# connect("draw", self, "_onNeedRedraw")



# func _draw_multiline_string(font, position, text, modulate=Color(1,1,1)):
# 	for ln in text.split("\n"):
# 		draw_string(font, position, ln, modulate)
# 		position.y += font.get_string_size("ABCEDFG").y
		

# func _draw():
# 	draw_rect(Rect2(Vector2(), rect_size), Color(0,0,0,.3))
# 	var text = self.text
# 	var s = "█"
# #	var s = "┌"
# 	for i in range(text.length()):
# 		s += "─"
# 	s += "┐\n│" + text + "│\n└"
# 	for i in range(text.length()):
# 		s += "─"
# 	s += "┘"
	
# 	_draw_multiline_string(get_font("font"), Vector2(), s)


# func _onNeedRedraw():
# 	# tuiOverlay.registerString(self, "jet")
# 	tui


func tuiDraw(overlay):
	print("tuiDraw()")
	tuiOverlay.registerString(self, tuiOverlay.boxString(rect_size, text))

