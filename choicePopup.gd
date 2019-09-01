extends CenterContainer


onready var text = $PanelContainer/VBoxContainer/text




var callback

var ready = false


func _ready():
	ready = true
	hide()

#	setupAndShow("poop", null, null)



func setupAndShow(s, cbObj, cbMethod):


	print($PanelContainer/VBoxContainer/text)
	print(text)

	text.text = s

#	callback = funcref(cbObj, cbMethod)
	show()





func _on_noButton_pressed():
	hide()


func _on_yesButton_pressed():
	callback.call_func()
	callback = null
	hide()

