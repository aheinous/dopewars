extends CenterContainer

onready var text = $PanelContainer/VBoxContainer/text
onready var buttonA = $PanelContainer/VBoxContainer/HBoxContainer/buttonA
onready var buttonB = $PanelContainer/VBoxContainer/HBoxContainer/buttonB

signal cancelPressed

func _ready():
	hide()


func _setupAndShow(desc, lblA, lblB):
	text.text = desc
	buttonA.text = lblA
	buttonB.text = lblB
	show()


func _on_cancelButton_pressed():
	hide()
	emit_signal("cancelPressed")


func _on_buttonA_pressed():
	pass


func _on_buttonB_pressed():
	pass
