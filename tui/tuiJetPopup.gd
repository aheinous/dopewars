extends "res://tui/tuiPopup.gd"

signal placeButtonPressed

const TUIButton = preload("res://tui/tuiButton_pure.tscn")
const TUILabel = preload("res://tui/tuiLabel_pure.tscn")

onready var vbox = $Panel/tuiVBox

var placeButtons = []

func _ready():
	for place in gameModel.places():
		var button = TUIButton.instance()
		button.text = place
		vbox.add_child(button)
		button.connect("pressed", self, "onPlaceButtonPressed", [place])
		button.sound = button.Sounds.train
		placeButtons.append(button)
	var spacer = TUILabel.instance()
	vbox.add_child(spacer)
	spacer.text = ""
	var cancelButton = TUIButton.instance()
	cancelButton.text = "Cancel"
	vbox.add_child(cancelButton)
	cancelButton.connect("pressed", self, "_on_cancelButton_pressed")
	refresh()


func setupAndShow():
	for button in placeButtons:
		button.disabled = (button.text == gameModel.stats().curPlace)
	_showPopup()


func onPlaceButtonPressed(place):
	_hidePopup()
	emit_signal("placeButtonPressed", place)


func _on_cancelButton_pressed():
	_hidePopup()

