extends "res://tui/tuiCenter.gd"

signal done

onready var panel = $Panel

func _showPopup():
	TUI.activeSubtree = self
	show()


func _hidePopup():
	TUI.activeSubtree = null
	hide()
	emit_signal("done")



# func _on_tuiPopup_resized():
# 	# panel.recenter()
# 	refresh()
