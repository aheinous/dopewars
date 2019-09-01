extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$CenterContainer.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	pass # Replace with function body.
#	$PopupPanel/VBoxContainer/Label.text = 'fafdsdfsdfasdfasdfasdfasfasfasfsadfasdfsdafsadfasfarts'
#	$PopupPanel.popup()
	doPopup('fafdsdfsdfasdfasdfasdfasfasfasfsadfasdfsdafsadfasfarts')


func _on_Button3_pressed():
	pass # Replace with function body.
	doPopup('farts')


func _on_Button2_pressed():
	pass # Replace with function body.
	doPopup('asdlf;klsdfk;lsd\n;lsdkf;sldfk;lsdakf;lsdakf;lasdkf;lsdakf;lsdakf;asldf\nasd;lfkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk\n\n\n\n\n\\n\n\n\n\n\n\ndfdfgdfdfgdfgdfg')





func doPopup(s):
	$CenterContainer/PanelContainer/VBoxContainer2/Label.text = s
	$CenterContainer.show()


var cnt = 0

func _on_poopbutton_pressed():
	pass # Replace with function body.
	match cnt:
		0:
			$PopupPanel/VBoxContainer/Label.text = 'farts'
		1:
			$PopupPanel/VBoxContainer/Label.text = 'asdlf;klsdfk;lsd\n;lsdkf;sldfk;lsdakf;lsdakf;lasdkf;lsdakf;lsdakf;asldf\nasd;lfkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk\n\n\n\n\n\\n\n\n\n\n\n\ndfdfgdfdfgdfgdfg'
	cnt += 1

func _on_closebutton_pressed():
	pass # Replace with function body.
	$CenterContainer.hide()

