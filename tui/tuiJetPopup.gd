extends "res://tui/tuiPopup.gd"

signal placeButtonPressed

const TUIButton = preload("res://tui/tuiButton_pure.tscn")

onready var cancelButton = $Panel/cancelButton

func _ready():
	var charPos = Vector2(1,1)
	var maxCharWidth = 0
	for place in gameModel.places():
		var button = TUIButton.instance()
		button.text = place
		panel.add_child(button)
		button.connect("pressed", self, "onPlaceButtonPressed", [place])
		button.rect_position = (charPos * TUI.cSize)
		maxCharWidth = max(maxCharWidth, button.charSize().x)
		charPos.y += button.charSize().y

	charPos.y += 1 # spacer
	cancelButton.rect_position = charPos * TUI.cSize
	charPos.y += cancelButton.charSize().y

	for button in panel.get_children():
		button.rect_size.x = maxCharWidth * TUI.cWidth

	panel.rect_size = Vector2(maxCharWidth+2, charPos.y+1) * TUI.cSize
	panel.recenter()



func setupAndShow():
	for button in panel.get_children():
		button.disabled = (button.text == gameModel.stats().curPlace)
	_showPopup()


func onPlaceButtonPressed(place):
	_hidePopup()
	emit_signal("placeButtonPressed", place)


func _on_cancelButton_pressed():
	_hidePopup()


func _on_tuiJetPopup_resized():
	panel.recenter()
	
