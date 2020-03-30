extends "res://tui/tuiElement.gd"

var _halfButton = false
export var disabled := false
export var text := 'default'
signal pressed

export var errorOnPress := false

export var pressTriggerAction : String = ''

#onready var blipSound = $'blipSound'
#onready var bee = $'blipSound'


enum Sounds {none, blip, beep, train, error}

export (Sounds) var sound = Sounds.blip

onready var _sounds = {
	Sounds.blip : $blipSound,
	Sounds.beep : $beepSound,
	Sounds.train : $trainSound,
	Sounds.error : $errorSound
} 



func _onSelfPressed():
	print('button "', text, '" pressed')
	if errorOnPress:
		_sounds[Sounds.error].play()
	else:
		if sound != Sounds.none:
			_sounds[sound].play()

func _ready():
	TUI.registerElement(self)
	connect("pressed", self, "_onSelfPressed")
	setText(text)

func tuiDraw(tui):
	if _halfButton:
		tui.drawToTUI(self, util.skinnyButtonStr(charSize, text))
	else:
		tui.drawToTUI(self, util.boxString(charSize, text))



func setHalfButton(b):
	_halfButton = b
	refreshCharSize()



func setText(s:String):
	text = s
	refreshCharSize()


	
func getMinCharSize():
	var cs = util.getCharSize(text)
	cs += Vector2(2,0) if _halfButton else Vector2(2,2)
	return cs


func is_disabled():
	return disabled


func _input(event):
	if not is_visible_in_tree() or not TUI._inActiveSubtree(self):
		return
	if pressTriggerAction.length() > 0 and event.is_action_pressed(pressTriggerAction):
		emit_signal('pressed')

