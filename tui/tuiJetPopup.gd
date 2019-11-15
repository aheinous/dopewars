extends Control

const TUIButton = preload("tuiButton.tscn")

signal placeButtonPressed


onready var panel = $Panel
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
	recenter()


func recenter():
	panel.rect_position = util.vec2_roundToMult((self.rect_size - panel.rect_size) / 2, TUI.cSize) 

func charSize():
	return Vector2(rect_size.x/TUI.cWidth, rect_size.y/TUI.cHeight)


func go():
	show()


func onPlaceButtonPressed(place):
	hide()
	emit_signal("placeButtonPressed", place)


func _on_cancelButton_pressed():
	hide()


func _on_tuiJetPopup_resized():
	recenter()
