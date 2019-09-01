
extends CenterContainer

var drug = "drug"

onready var text = $PanelContainer/VBoxContainer/text

signal buyPressed
signal sellPressed

func _ready():
	hide()



func setupAndShow(drug):
	self.drug = drug
	text.text = "Buy or sell %s?" % drug
	show()


func _on_buyButton_pressed():
	print('buy pressed ', drug)
	emit_signal("buyPressed", drug)
	hide()


func _on_sellButton_pressed():
	print('sell pressed ', drug)
	emit_signal("sellPressed", drug)
	hide()


func _on_cancelButton_pressed():
	hide()

