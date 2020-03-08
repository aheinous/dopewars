extends "res://tui/tuiPopup.gd"

onready var panel = $Panel
onready var text = $Panel/text
onready var amntChooser = $Panel/amntChooser
onready var okayButton = $Panel/okayButton
onready var cancelButton = $Panel/cancelButton


func _refresh():
	var charPos = Vector2(1,1)
	text.rect_position = TUI.cSize * charPos
	charPos.y += text.charSize().y
	amntChooser.rect_position = TUI.cSize * charPos
	charPos.y += amntChooser.charSize().y
	cancelButton.rect_position = TUI.cSize * charPos
	charPos.x += cancelButton.charSize().x
	okayButton.rect_position = TUI.cSize * charPos
	panel.rect_size = TUI.cSize * Vector2(amntChooser.charSize().x+2, charPos.y+4)
	panel.recenter()


func _ready():
	hide()


func _on_cancelButton_pressed():
	pass


func _on_okayButton_pressed():
	pass


func _on_text_resized():
	_refresh()

func _on_amntPopup_resized():
	panel.recenter()
