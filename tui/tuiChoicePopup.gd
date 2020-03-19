extends "res://tui/tuiPopup.gd"

signal yesPressed
signal noPressed

onready var text = $Panel/tuiVBox/Text/
onready var yesButton = $Panel/tuiVBox/tuiHBox/YesButton
onready var noButton = $Panel/tuiVBox/tuiHBox/NoButton




func _ready():
	hide()


func setupAndShow(var msg):
	var charPos = Vector2(1,1)
	text.setText(msg)
	_showPopup()
	

func _on_NoButton_pressed():
	_hidePopup()
	emit_signal("noPressed")


func _on_YesButton_pressed():
	_hidePopup()
	emit_signal("yesPressed")
