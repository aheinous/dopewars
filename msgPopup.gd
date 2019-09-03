extends CenterContainer

signal okayPressed

onready var text = $PanelContainer/VBoxContainer/Text


func _ready():
	hide()

func setupAndShow(var msg):
#	text.text = PoolStringArray(msgs).join("\n\n")
#	yield(get_tree(), "idle_frame")
	text.text = msg
	show()




func _on_OkayButton_pressed():
	hide()
	emit_signal("okayPressed")
#	queue_free()
