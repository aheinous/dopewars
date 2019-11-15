extends Control

const TUIButton = preload("tuiButton.tscn")

signal placeButtonPressed

# onready var marginContainer = $PanelContainer/MarginContainer
# onready var placesContainer = $PanelContainer/MarginContainer/VBoxContainer/places
# onready var outterVbox = $PanelContainer/MarginContainer/VBoxContainer

onready var panel = $Panel
onready var cancelButton = $Panel/cancelButton


func _ready():

	# why do I have to set this?
	# anchor_left = 0
	# anchor_top = 0
	# anchor_right = 1
	# anchor_bottom = 1


	print("pos, size:", rect_position, rect_size)

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

#	self.rect_position = Vector2()
	print('self.rect_size: ', self.rect_size)
	panel.rect_position = (self.rect_size - panel.rect_size) / 2 # center

func charSize():
	return Vector2(rect_size.x/TUI.cWidth, rect_size.y/TUI.cHeight)


#func _process(delta):
#	var root = $"/root/Game"
##	print("%s pos , size: %s, %s" % [root.name, 0, 0])
#	print("%s pos , size: %s, %s" % [root.name, root.rect_position, root.rect_size])
#	print("\tpos, size:", rect_position, rect_size)

# func _ready():
# 	hide()
# 	outterVbox.add_constant_override("separation", TUI.cHeight)
# 	marginContainer.add_constant_override("margin_right", TUI.cWidth)
# 	marginContainer.add_constant_override("margin_left", TUI.cWidth)
# 	marginContainer.add_constant_override("margin_top", TUI.cHeight)
# 	marginContainer.add_constant_override("margin_bottom", TUI.cHeight)
	

func go():
	# for button in placesContainer.get_children():
	# 	button.queue_free()


# 	for place in gameModel.places():
# 		var button = TuiButton.instance()
# 		button.text = place
# #		print(place, ", ", gameModel.curPlace)
# 		if place == gameModel.stats().curPlace:
# #			print("disabl;ed")
# 			button.disabled = true
# 		placesContainer.add_child(button)
# 		button.connect("pressed", self, "onPlaceButtonPressed", [place])

	# why do I have to set this?
	# anchor_left = 0
	# anchor_top = 0
	# anchor_right = 1
	# anchor_bottom = 1

	print(	panel.rect_position , self.rect_size , panel.rect_size)

	panel.rect_position = (self.rect_size - panel.rect_size) / 2 # center
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

func _on_tuiJetPopup_item_rect_changed():
	pass # Replace with function body.
	print('why?')


func _on_tuiJetPopup_resized():
	pass # Replace with function body.
	print("RESIZED")
	var root = get_parent()
	print("%s pos , size: %s, %s" % [root.name, root.rect_position, root.rect_size])
	print("\tpos, size:", rect_position, rect_size)
	panel.rect_position = (self.rect_size - panel.rect_size) / 2 # center