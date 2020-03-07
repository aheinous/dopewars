extends Control

onready var panel = $Panel
onready var text = $Panel/text
onready var amntChooser = $Panel/amntChooser
onready var okayButton = $Panel/okayButton
onready var cancelButton = $Panel/cancelButton


func _refresh():
	var charPos = Vector2(1,1)
	text.rect_position = TUI.cSize * charPos
	charPos.y += text.charSize().y
	amntChooser.rect_position = TUI.cSize * charPos
	charPos.y += amntChooser.charSize().y
	cancelButton.rect_position = TUI.cSize * charPos
	charPos.x += cancelButton.charSize().x
	okayButton.rect_position = TUI.cSize * charPos
	panel.rect_size = TUI.cSize * Vector2(amntChooser.charSize().x+2, charPos.y+4)
	panel.tuiDraw(TUI)
	_recenter()
	

func _recenter():
	panel.rect_position = util.vec2_roundToMult((self.rect_size - panel.rect_size) / 2, TUI.cSize) 


func _ready():
	hide()


func _on_cancelButton_pressed():
	pass


func _on_okayButton_pressed():
	pass


func _on_text_resized():
	_refresh()

func _on_amntPopup_resized():
	_recenter()
