extends VBoxContainer

signal itemButtonPressed

const TuiButton = preload("res://tui/tuiButton_pure.tscn")
const TuiLabel = preload("res://tui/tuiLabel_pure.tscn")


func _addHeader(colWidths):
	# var header = Label.new()
	var header = TuiLabel.instance()
	var font = header.get_font("font")
	
	header.text = "%s %s %s" % [
			util.rpad_chars(colWidths[0], "NAME"),
			util.rpad_chars(colWidths[1], "PRICE"),
			util.lpad_chars(colWidths[2], "QUANTITY") ]
#	header.align = Label.ALIGN_CENTER
	self.add_child(header)


func _rmvAllChildren():
	for child in self.get_children():
		child.queue_free()


func _addSpacer():
	var spacer = Control.new()
	spacer.rect_min_size.y = 8
	add_child(spacer)

# # override
# func getNumSections():
# 	pass



func _addButton(item, colWidths):
	var button = TuiButton.instance()
	var font = button.get_font("font")

	button.setText ("%s %s %s" % [
								util.rpad_chars(colWidths[0], item.itemName),
								util.lpad_chars(colWidths[1],
									"$"+util.toCommaSepStr(item.price) if item.price != -1 else "Ain't here"),
								util.lpad_chars(colWidths[2], str(item.quantity))
								])
	button.setHalfButton(true)
	self.add_child(button)
	button.connect("pressed", self, "onItemButtonPressed", [item.itemName])

func _populate(storeItems, colWidths):
	_rmvAllChildren()
	_addHeader(colWidths)

	var section = 0

	for item in storeItems:
		if section == 0 and item.price == -1:
			_addSpacer()
			section += 1
		_addButton(item, colWidths)



func onItemButtonPressed(itemName):
	print("item button pressed")
	emit_signal("itemButtonPressed", itemName)
