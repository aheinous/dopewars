extends "res://tui/tuiPopup.gd"

signal placeButtonPressed

const TUIButton = preload("res://tui/tuiButton_pure.tscn")
const TUILabel = preload("res://tui/tuiLabel_pure.tscn")

onready var vbox = $Panel/tuiVBox
onready var leftColumn = $Panel/tuiVBox/columnHBox/leftVBox
onready var rightColumn = $Panel/tuiVBox/columnHBox/rightVBox

var placeButtons = []

func _ready():	
	var left = true
	var hbox = null
	for place in gameModel.places():
		var button = TUIButton.instance()
		button.text = place
		button.connect("pressed", self, "onPlaceButtonPressed", [place])
		placeButtons.append(button)
		if left:
			leftColumn.add_child(button)
			left = false
		else:
			rightColumn.add_child(button)
			left = true

	var spacer = TUILabel.instance()
	vbox.add_child(spacer)
	spacer.text = ""
	var cancelButton = TUIButton.instance()
	cancelButton.text = "Cancel"
	cancelButton.pressTriggerAction = 'ui_cancel'
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

