extends CenterContainer

onready var text = $PanelContainer/VBoxContainer/Text


func _ready():
	hide()

func setupAndShow(var msgs):
	text.text = PoolStringArray(msgs).join("\n\n")
#	yield(get_tree(), "idle_frame")
	show()




func _on_OkayButton_pressed():
	hide()
#	queue_free()
