tool
extends VBoxContainer


signal drugButtonPressed

func _init():
	if Engine.is_editor_hint():
		editorPreview()

func editorPreview():
	var drugs := [	structs.DrugData.new('Weed', 720, 10),
					structs.DrugData.new('MDMA', 2400, 10),
					structs.DrugData.new('Cocaine', 18223, 3),
					structs.DrugData.new('Heroin', -1, 1)
					]
	populate(drugs)

func populate(drugs = null):

	if drugs == null:
		drugs = gameModel.drugsHere() + gameModel.drugsOwnedAndNotHere()

	for child in self.get_children():
		child.queue_free()

	var header = Label.new()
	var font = header.get_font("font")
	var Util = load("res://util.gd")
	header.text = "%s %s %s" % [
									Util.rpad_pixels(font, config.colWidths[0], "Name"),
									Util.rpad_pixels(font, config.colWidths[1], "Price"),
									Util.lpad_pixels(font, config.colWidths[2], "Quantity")
									]
	header.align = Label.ALIGN_CENTER
	self.add_child(header)
	for drug in drugs:
		var button = Button.new()
		font = button.get_font("font")

		button.text = "%s %s %s" % [
									Util.rpad_pixels(font, config.colWidths[0], drug.name),
									Util.lpad_pixels(font, config.colWidths[1], "$"+str(drug.price) if drug.price != -1 else "Ain't here"),
									Util.lpad_pixels(font, config.colWidths[2], str(drug.quantity))
									]
		self.add_child(button)
		button.connect("pressed", self, "onDrugButtonPressed", [drug.name])




func onDrugButtonPressed(drug):
	print("drug button pressed: ", drug)
	emit_signal("drugButtonPressed", drug)
