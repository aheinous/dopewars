extends Control

func recenter():
	self.rect_position = util.vec2_roundToMult((get_parent().rect_size - self.rect_size) / 2, TUI.cSize) 


func charSize():
	return Vector2(rect_size.x/TUI.cWidth, rect_size.y/TUI.cHeight)

func refreshMinSize():
	set_custom_minimum_size(charSize() * TUI.cSize)