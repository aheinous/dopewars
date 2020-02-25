extends CenterContainer

const TuiButton = preload("tui/tuiButton.tscn")

signal placeButtonPressed

onready var marginContainer = $PanelContainer/MarginContainer
onready var placesContainer = $PanelContainer/MarginContainer/VBoxContainer/places
onready var outterVbox = $PanelContainer/MarginContainer/VBoxContainer

#func _ready():
#	for place in gameModel.places():
#		var button = Button.new()
#		button.text = place
#		placesContainer.add_child(button)
#		button.connect("pressed", self, "onPlaceButtonPressed", [place])



func _ready():
	hide()
	outterVbox.add_constant_override("separation", TUI.cHeight)
	marginContainer.add_constant_override("margin_right", TUI.cWidth)
	marginContainer.add_constant_override("margin_left", TUI.cWidth)
	marginContainer.add_constant_override("margin_top", TUI.cHeight)
	marginContainer.add_constant_override("margin_bottom", TUI.cHeight)
	

func go():
	for button in placesContainer.get_children():
		button.queue_free()


	for place in gameModel.places():
		var button = TuiButton.instance()
		button.text = place
#		print(place, ", ", gameModel.curPlace)
		if place == gameModel.stats().curPlace:
#			print("disabl;ed")
			button.disabled = true
		placesContainer.add_child(button)
		button.connect("pressed", self, "onPlaceButtonPressed", [place])

	show()


func onPlaceButtonPressed(place):
	hide()
	emit_signal("placeButtonPressed", place)


func _on_cancelButton_pressed():
	hide()


# func debugPrint():
# 	var cancelButton =$"PanelContainer/VBoxContainer/cancelButton"
# 	print(cancelButton.rect_min_size)
# 	print(cancelButton.get_custom_minimum_size())
	
	
# 	if $"PanelContainer/VBoxContainer/places".get_child_count() > 0:
# 		var placeButton =$"PanelContainer/VBoxContainer/places".get_children()[0]
# 		print(placeButton.rect_min_size)
# 		print(placeButton.get_custom_minimum_size())
