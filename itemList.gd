extends VBoxContainer

signal itemButtonPressed



func _addHeader(colWidths):
	var header = Label.new()
	var font = header.get_font("font")
#	var util = load("res://util.gd")
	header.text = "%s %s %s" % [
			util.rpad_pixels(font, colWidths[0], "Name"),
			util.rpad_pixels(font, colWidths[1], "Price"),
			util.lpad_pixels(font, colWidths[2], "Quantity") ]
	header.align = Label.ALIGN_CENTER
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
	var button = Button.new()
	var font = button.get_font("font")

	button.text = "%s %s %s" % [
								util.rpad_pixels(font, colWidths[0], item.name),
								util.lpad_pixels(font, colWidths[1],
									"$"+util.toCommaSepStr(item.price) if item.price != -1 else "Ain't here"),
								util.lpad_pixels(font, colWidths[2], str(item.quantity))
								]
	self.add_child(button)
	button.connect("pressed", self, "onItemButtonPressed", [item.name])

func _populate(storeItems, colWidths):
	_rmvAllChildren()
	_addHeader(colWidths)

	var section = 0

	for item in storeItems:
		if section == 0 and item.price == -1:
			_addSpacer()
			section += 1
		_addButton(item, colWidths)



func onItemButtonPressed(name):
	emit_signal("itemButtonPressed", name)
