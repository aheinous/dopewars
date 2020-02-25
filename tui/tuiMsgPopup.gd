extends Control

signal okayPressed

#onready var text = $PanelContainer/VBoxContainer/Text
onready var panel = $Panel
onready var text = $Panel/Text
onready var okayButton = $Panel/OkayButton




func _ready():
	hide()


func setupAndShow(var msg):

	print("tuiMsgPopup.setupAndShow() pos %s, sz: %s" % [rect_position, rect_size])

	TUI.activeSubtree = self
#	text.text = msg
	var charPos = Vector2(1,1)

	text.setText(msg)
	text.rect_position = charPos * TUI.cSize
	charPos.y += text.charSize().y

	
	var buttonx = max(1, (text.charSize().x - okayButton.charSize().x) / 2)
	okayButton.rect_position = Vector2(buttonx, charPos.y) * TUI.cSize
	charPos.y += okayButton.charSize().y
	panel.rect_position = TUI.cSize
	panel.rect_size = Vector2(max(okayButton.charSize().x, text.charSize().x)+2, charPos.y+1) * TUI.cSize
	recenter()
	show()

func recenter():
	panel.rect_position = util.vec2_roundToMult((self.rect_size - panel.rect_size) / 2, TUI.cSize) 

func finish():
	TUI.activeSubtree = null
	hide()

func _on_OkayButton_pressed():
	finish()
	emit_signal("okayPressed")
#	queue_free()


func _on_tuiMsgPopup_resized():
	recenter()
