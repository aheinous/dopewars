extends "res://tui/tuiPopup.gd"

onready var text = $Panel/tuiVBox/text
onready var amntChooser = $Panel/tuiVBox/amntChooser
onready var okayButton = $Panel/tuiVBox/tuiHBox/okayButton
onready var cancelButton = $Panel/tuiVBox/tuiHBox/cancelButton
onready var tuiHBox = $Panel/tuiVBox/tuiHBox
onready var tuiVBox = $Panel/tuiVBox/

func _ready():
	hide()


func _on_text_resized():
	refresh()
