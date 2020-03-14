extends "res://tui/tuiPopup.gd"

onready var text = $Panel/tuiVBox/text
onready var amntChooser = $Panel/tuiVBox/amntChooser
onready var okayButton = $Panel/tuiVBox/tuiHBox/okayButton
onready var cancelButton = $Panel/tuiVBox/tuiHBox/cancelButton
onready var tuiHBox = $Panel/tuiVBox/tuiHBox
onready var tuiVBox = $Panel/tuiVBox/


#func refresh():
#	if text == null: # not ready yet
#		return
#
#	tuiVBox.charPos = Vector2(1,1)
#	tuiVBox.refresh()
#	panel.charSize = tuiVBox.charSize + Vector2(2,2)
#	print(tuiVBox.charSize, panel.charSize, '<-')
#	panel.recenter()


func _ready():
	
	hide()


func _on_cancelButton_pressed():
	pass


func _on_okayButton_pressed():
	pass


func _on_text_resized():
	refresh()

func _on_amntPopup_resized():
#	panel.recenter()
	pass
