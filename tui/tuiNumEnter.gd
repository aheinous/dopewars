extends "res://tui/tuiPopup.gd"

onready var buttonGrid = $"Panel/tuiVBox/tuiVBox/buttonGrid"
onready var numLabel =   $"Panel/tuiVBox/tuiVBox/Panel/tuiLabel"
onready var textLabel =  $"Panel/tuiVBox/tuiVBox/tuiLabel"
onready var okayButton = $"Panel/tuiVBox/tuiHBox/okayButton"

const TuiButton = preload("res://tui/tuiButton_pure.tscn")
const HBox = preload("res://tui/tuiHBox.tscn")

var maxval


var maxchars = 12

const syms = [		
	[' 1 ', ' 2 ', ' 3 '],
	[' 4 ', ' 5 ', ' 6 '],
	[' 7 ', ' 8 ', ' 9 '],
	[' 0 ', ' k ', ' M '],
	[' <- ', ' Max '] 
]


var preunit = ''
var usrtext = ''

func _ready():
	for rowNum in range(syms.size()):
		var row = HBox.instance()
		buttonGrid.add_child(row)
		row.alignment = row.AlignMode.ALIGN_CENTER
		for colNum in range(syms[rowNum].size()):
			var button = TuiButton.instance()
			button.setText(syms[rowNum][colNum])
			row.add_child(button)
			button.connect("pressed", self, "_onButtonPressed", 
					[syms[rowNum][colNum].strip_edges()])
			

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
	return min(val, maxval)


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
		'<-':
			usrtext = usrtext.substr(0,usrtext.length()-1)
		_:
			if usrtext.length() >= maxchars:
				return
			if usrtext.length() > 0 and usrtext[-1] in ['k', 'M']:
				return
			if usrtext.length() == 0 and s in ['k', 'M', '0']:
				return
			usrtext += s
	_updateDispText()


func _setupAndShow(start, maxval, preunit, text, verb):
	usrtext = '' if start==0 else start as String
	self.preunit = preunit
	self.maxval = maxval
	textLabel.setText(text)
	okayButton.text = verb
	_updateDispText()
	_showPopup()


func _on_okayButton_pressed():
	pass


func _on_cancelButton_pressed():
	_hidePopup()
