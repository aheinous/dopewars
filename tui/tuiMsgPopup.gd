extends "res://tui/tuiPopup.gd"

signal okayPressed


onready var text = $Panel/tuiVBox/tuiHBox/Text



func _ready():
	hide()


func setupAndShow(var msg):
	text.setText(msg)

	refresh()
	_showPopup()


func _on_OkayButton_pressed():
	_hidePopup()
	emit_signal("okayPressed")
