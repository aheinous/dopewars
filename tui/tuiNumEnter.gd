extends "res://tui/tuiPopup.gd"

onready var buttonGrid = $"Panel/tuiVBox/tuiVBox/buttonGrid"
onready var numLabel =   $"Panel/tuiVBox/tuiVBox/Panel/tuiLabel"
onready var textLabel =  $"Panel/tuiVBox/tuiVBox/tuiLabel"
onready var okayButton = $"Panel/tuiVBox/tuiHBox/okayButton"

const TuiButton = preload("res://tui/tuiButton_pure.tscn")
const HBox = preload("res://tui/tuiHBox.tscn")

var maxval


var maxchars = 12

#const syms = [		
#	[' 1 ', ' 2 ', ' 3 '],
#	[' 4 ', ' 5 ', ' 6 '],
#	[' 7 ', ' 8 ', ' 9 '],
#	[' 0 ', ' k ', ' M '],
#	[' <- ', ' Max '] 
#]


const syms = [		
	[' 1 ', ' 2 ', ' 3 ', ' <-- '],
	[' 4 ', ' 5 ', ' 6 ', ' Max '],
	[' 7 ', ' 8 ', ' 9 ', '  +  '],
	[' 0 ', ' k ', ' M ', '  -  '],
]



var preunit = ''
var usrtext = ''
var instaclear = true

func _ready():
	for rowNum in range(syms.size()):
		var row = HBox.instance()
		buttonGrid.add_child(row)
		row.alignment = row.AlignMode.ALIGN_BEGIN
		for colNum in range(syms[rowNum].size()):
			var button = TuiButton.instance()
			button.setText(syms[rowNum][colNum])
			row.add_child(button)
			button.connect("pressed", self, "_onButtonPressed", 
					[syms[rowNum][colNum].strip_edges()])
			button.sound = button.Sounds.beep
	numLabel.numColumns = maxchars + preunit.length()
			

func getValue():
	if usrtext.length() == 0:
		return 0
	var suffix = ''
	var s = usrtext

	if s[-1] in ['k', 'M']:
		suffix = s[-1]
		s = s.substr(0, s.length()-1)
	var val = s.to_int()
	match suffix:
		'k':
			val *= 1000
		'M':
			val *= (1000*1000)
	return val


func _updateDispText():
	if usrtext.length() == 0:
		numLabel.setText(preunit + '0')
		return
	var suffix = ''
	var s = usrtext

	if s[-1] in ['k', 'M']:
		suffix = s[-1]
		s = s.substr(0, s.length()-1)
	s = util.sToCommaSepStr(s)
	numLabel.setText(preunit + s + suffix)


	
func _onButtonPressed(s):
	match s:
		'Max':
			usrtext = maxval as String
			instaclear = true
		'<--':
			usrtext = usrtext.substr(0,usrtext.length()-1)
		'+':
			usrtext = (getValue() + 1) as String
		'-':
			if getValue() > 0:
				usrtext = (getValue() - 1) as String
		_:
			if usrtext.length() >= maxchars:
				return
			if usrtext.length() > 0 and usrtext[-1] in ['k', 'M']:
				return
			if (usrtext.length() == 0 or instaclear) and s in ['k', 'M', '0']:
				return
			
			if instaclear:
				instaclear = false
				usrtext = s
			else:
				usrtext += s
	_updateDispText()
	okayButton.disabled = getValue() > maxval


func _setupAndShow(start, maxval, preunit, text, verb):
	usrtext = '' if start==0 else start as String
	self.preunit = preunit
	self.maxval = maxval
	textLabel.setText(text)
	okayButton.text = verb
	instaclear = true
	_updateDispText()
	_showPopup()


func _on_okayButton_pressed():
	pass


func _on_cancelButton_pressed():
	_hidePopup()


func _input(event):
	if not is_visible_in_tree() or not TUI._inActiveSubtree(self):
		return
	if event is InputEventKey and event.pressed:
#		print('focus:', is_visible_in_tree(), has_focus(), TUI._inActiveSubtree(self))
		print('key press: ', event.scancode)
		var sc = event.scancode
		var s = ''
		if sc >= KEY_0 and sc <= KEY_9: 
			s = OS.get_scancode_string(sc)
		elif sc >= KEY_KP_0 and sc <= KEY_KP_9: 
			s = (sc - KEY_KP_0) as String
		elif sc == KEY_K:
			s = 'k'
		elif sc == KEY_M:
			s = 'M'
		elif sc == KEY_BACKSPACE:
			s = '<--'
		elif event.get_unicode() == 45: # minus
			s = '-'
		elif event.get_unicode() == 43: # plus
			s = '+'
		
#		print('s: "', s , '" ie: "', OS.get_scancode_string(sc), '"' , event.get_unicode())
		if s.length() > 0:
			_onButtonPressed(s)
			refresh()
