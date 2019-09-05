tool
extends Control

onready var label = $Label
onready var slider = $HBoxContainer/HSlider
onready var spinBox = $HBoxContainer/SpinBox


var value setget , getValue
export var verb = "Verb" setget setVerb

func _ready():
	if Engine.is_editor_hint():
		setup(verb, 100, 73)
	setVerb(verb)

func setVerb(verb_):
	print("setting verb: ", verb_)
	verb = verb_
	if $Label != null:
		$Label.text = verb_ + " how many?"
	#label.text = verb + " how many?"

func setup(verb, max_value, start=-1):

	print("amntChooser setup: %s, %s" % [verb, max_value])
	assert(max_value > 0)

	if start == -1:
		start = max_value

	start = clamp(start, 0, max_value)

	if verb == "Pay":
			label.text = verb + " how much?"
	else:
		label.text = verb + " how many?"

	slider.max_value = max_value
	slider.value = start

	spinBox.max_value = max_value
	spinBox.value = start


func getValue():
	return spinBox.value



func _on_valueChanged(value):
	slider.value = value
	spinBox.value = value

