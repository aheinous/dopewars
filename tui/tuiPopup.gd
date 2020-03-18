extends "res://tui/tuiCenter.gd"

signal done

onready var panel = $Panel

func _showPopup():
	TUI.pushActiveSubtree(self)
	show()


func _hidePopup():
	TUI.popActiveSubtree()
	hide()
	emit_signal("done")
