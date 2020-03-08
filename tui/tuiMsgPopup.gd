extends "res://tui/tuiPopup.gd"

signal okayPressed

#onready var text = $PanelContainer/VBoxContainer/Text
onready var panel = $Panel
onready var text = $Panel/Text
onready var okayButton = $Panel/OkayButton




func _ready():
	hide()


func setupAndShow(var msg):
	var charPos = Vector2(1,1)

	text.setText(msg)
	text.rect_position = charPos * TUI.cSize
	charPos.y += text.charSize().y

	
	var buttonx = max(1, (text.charSize().x - okayButton.charSize().x) / 2)
	okayButton.rect_position = Vector2(buttonx, charPos.y) * TUI.cSize
	charPos.y += okayButton.charSize().y
	panel.rect_position = TUI.cSize
	panel.rect_size = Vector2(max(okayButton.charSize().x, text.charSize().x)+2, charPos.y+1) * TUI.cSize
	panel.recenter()
	_showPopup()
	



func _on_OkayButton_pressed():
	_hidePopup()
	emit_signal("okayPressed")


func _on_tuiMsgPopup_resized():
	panel.recenter()
