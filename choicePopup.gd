extends CenterContainer


signal yesPressed
signal noPressed

onready var text = $PanelContainer/VBoxContainer/text



func _ready():
	hide()




func setupAndShow(s):
	text.text = s
	show()


func _on_noButton_pressed():
	hide()
	emit_signal("noPressed")


func _on_yesButton_pressed():
	hide()
	emit_signal("yesPressed")

