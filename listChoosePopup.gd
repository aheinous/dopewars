extends "res://tui/tuiPopup.gd"

onready var text = $Panel/VBoxContainer/text
onready var buttonA = $Panel/VBoxContainer/HBoxContainer/buttonA
onready var buttonB = $Panel/VBoxContainer/HBoxContainer/buttonB


func _ready():
	hide()


func _setupAndShow(desc, lblA, lblB):
	text.text = desc
	buttonA.text = lblA
	buttonB.text = lblB
	refresh()
	_showPopup()


func _on_cancelButton_pressed():
	_hidePopup()


func _on_buttonA_pressed():
	pass


func _on_buttonB_pressed():
	pass
