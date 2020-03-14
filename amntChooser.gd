extends "res://tui/tuiElement.gd"

onready var label = $label
onready var m10_button = $m10
onready var m1_button =  $m1
onready var p1_button =  $p1
onready var p10_button = $p10
onready var max_button = $max


var value
var max_value
var verb 

func _ready():
	label.rect_position =   	TUI.cSize * Vector2(0,	0)
	m10_button.rect_position = 	TUI.cSize * Vector2(0,	1)
	m1_button.rect_position = 	TUI.cSize * Vector2(5,	1)
	p1_button.rect_position = 	TUI.cSize * Vector2(9,	1)
	p10_button.rect_position = 	TUI.cSize * Vector2(13,	1)
	max_button.rect_position = 	TUI.cSize * Vector2(18,	1)
	# valueLabel.rect_position = 	TUI.cSize * Vector2(4,	4  )


func setup(verb, max_value, start=-1):

	print("amntChooser setup: %s, %s" % [verb, max_value])

	self.verb = verb
	self.max_value = max_value

	if start == -1:
		start = max_value

	_setValue(start)


func getMinCharSize():
	return Vector2(23,4)

# func charSize():
# 	return Vector2(23, 4)

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
