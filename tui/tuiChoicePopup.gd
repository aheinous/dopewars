extends "res://tui/tuiPopup.gd"

signal yesPressed
signal noPressed

onready var text = $Panel/Text
onready var yesButton = $Panel/YesButton
onready var noButton = $Panel/NoButton




func _ready():
	hide()


func setupAndShow(var msg):
	var charPos = Vector2(1,1)

	text.setText(msg)
	text.rect_position = charPos * TUI.cSize
	charPos.y += text.charSize.y


	var buttonTotalWidth : int = yesButton.charSize.x + noButton.charSize.x
	var yesx : int = max(0, text.charSize.x / 2 - buttonTotalWidth / 2)
	
	# var buttonx = max(1, (text.charSize().x - okayButton.charSize().x) / 2)
	yesButton.rect_position = Vector2(yesx, charPos.y) * TUI.cSize
	noButton.rect_position = Vector2(yesx + yesButton.charSize.x, charPos.y) * TUI.cSize

#	var noButtonPos = charPos
#	noButtonPos.x = max(1 + yesButton.charSize().x, 1 + text.charSize().x - noButton.charSize().x)
#	noButton.rect_position = noButtonPos * TUI.cSize


	charPos.y += yesButton.charSize.y
	panel.rect_position = TUI.cSize
	panel.charSize = Vector2( max(yesButton.charSize.x+noButton.charSize.x, \
								text.charSize.x)+2, charPos.y+1)
	_showPopup()
	



func _on_NoButton_pressed():
	_hidePopup()
	emit_signal("noPressed")


func _on_YesButton_pressed():
	_hidePopup()
	emit_signal("yesPressed")


func _on_tuiMsgPopup_resized():
	panel.recenter()
