extends "res://tui/tuiElement.gd"

# signal done

func _showPopup():
	TUI.activeSubtree = self
	show()


func _hidePopup():
	TUI.activeSubtree = null
	hide()
	# emit_signal("done")

