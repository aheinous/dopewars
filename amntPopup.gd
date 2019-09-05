extends CenterContainer

var Util = preload("res://util.gd")

onready var text = $PanelContainer/VBoxContainer/text
onready var okayButton = $PanelContainer/VBoxContainer/HBoxContainer/okayButton
onready var amntChooser = $PanelContainer/VBoxContainer/AmntChooser

func _ready():
	hide()


func _on_cancelButton_pressed():
	pass


func _on_okayButton_pressed():
	pass

