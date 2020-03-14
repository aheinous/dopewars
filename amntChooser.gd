extends "res://tui/tuiElement.gd"

onready var label = $tuiVBox/label
onready var m10_button = $tuiVBox/tuiHBox/m10
onready var m1_button =  $tuiVBox/tuiHBox/m1
onready var p1_button =  $tuiVBox/tuiHBox/p1
onready var p10_button = $tuiVBox/tuiHBox/p10
onready var max_button = $tuiVBox/tuiHBox/max


var value
var max_value
var verb 




func setup(verb, max_value, start=-1):

	print("amntChooser setup: %s, %s" % [verb, max_value])

	self.verb = verb
	self.max_value = max_value

	if start == -1:
		start = max_value

	_setValue(start)


func getMinCharSize():
	return $"tuiVBox".getMinCharSize()

	

func _refreshText():
	var text
	if verb == "Pay" or verb == "Deposit" or verb == "Withdraw":
		text = verb + " how much?"
	else:
		text = verb + " how many?"

	text += ": " + String(value)
	label.text = text

func getValue():
	return value

func _setValue(newValue):
	if util.isNAN(newValue):
		newValue = 0
	if newValue > max_value:
		newValue = max_value
	if newValue < 0:
		newValue = 0
	self.value = newValue
	_refreshText()



func _on_m10_pressed(): 
	_setValue(value - 10)

func _on_m1_pressed(): 
	_setValue(value - 1)

func _on_p1_pressed(): 
	_setValue(value + 1)

func _on_p10_pressed(): 
	_setValue(value + 10)

func _on_max_pressed(): 
	_setValue(max_value)
