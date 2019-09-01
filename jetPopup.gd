extends CenterContainer


#signal placeButtonPressed

onready var placesContainer = $PanelContainer/VBoxContainer/places

#func _ready():
#	for place in gameModel.places():
#		var button = Button.new()
#		button.text = place
#		placesContainer.add_child(button)
#		button.connect("pressed", self, "onPlaceButtonPressed", [place])



func _ready():
	hide()

func go():
	for button in placesContainer.get_children():
		button.queue_free()


	for place in gameModel.places():
		var button = Button.new()
		button.text = place
#		print(place, ", ", gameModel.curPlace)
		if place == gameModel.curPlace:
#			print("disabl;ed")
			button.disabled = true
		placesContainer.add_child(button)
		button.connect("pressed", self, "onPlaceButtonPressed", [place])

	show()


func onPlaceButtonPressed(place):
	hide()
	gameModel.jet(place)


func _on_cancelButton_pressed():
	hide()
