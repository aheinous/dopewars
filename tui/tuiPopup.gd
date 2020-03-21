extends "res://tui/tuiCenter.gd"

signal done

onready var panel = $Panel

func _showPopup():
	TUI.pushActiveSubtree(self)
	show()
	refresh()


func _hidePopup(emitDone = true):
	TUI.popActiveSubtree()
	hide()
	if emitDone:
		emit_signal("done")
