extends Control


var lines := []
var cWidth := 0
var cHeight := 0
var nCols := 0
var nLines := 0


var redrawNeeded = true

export var font : Font


#onready var jetButton = $"../MarginContainer/VBoxContainer/jetButton"


func boxString(size, text):
	var box_nCols = round(size.x as float / cWidth) as int
	var box_nLines = round(size.y as float/ cHeight) as int
	box_nCols = max(box_nCols, text.length() + 2)
	box_nLines = max(box_nLines, 3)

	var s = "┌"
	for colnum in range(1, box_nCols-1):
		s += "─"
	s += "┐\n"

	s += "│" + util.lrpad_chars(box_nCols-2, text) + "│\n"

	s += "└"
	for colnum in range(1, box_nCols-1):
		s += "─"
	s += "┘"
	return s


func _drawTargets():
	var tgts = []
	for child in _childrenInDrawOrder($".."):
		if child.has_method("tuiDraw"):
			tgts.append(child)
	return tgts

func _childrenInDrawOrder(root):
	var drawOrder = []
	for child in root.get_children():
		drawOrder.append(child)
		drawOrder += _childrenInDrawOrder(child)
	return drawOrder


func _ready():
	connect("resized", self, "_onResized")
	mouse_filter = MOUSE_FILTER_IGNORE
#	jetButton.connect("draw", self, "onNeedRedraw")
	_onResized()
	tui_manager.overlay = self

func _gui_input(event):
	print('_gui_input(%s)' % event)


func _clear():
	var fillChar = " "
	var ln = ""

	lines = []

	for colnum in range(nCols):
		ln += fillChar

		
	# ln[-1] = '>'
	# ln[0] = '<'

	for linenum in range(nLines):
		lines.append(ln)

	# lines[0][0] = 's'
	# lines[-1][-1] = 'e'

func _onResized():
	print('onResized()')

	cWidth = font.get_string_size("aa").x - font.get_string_size("a").x
	cHeight = font.get_string_size("a").y
	nCols = rect_size.x / cWidth
	nLines = rect_size.y / cHeight

	_clear()

	print('cWidth x cHeight: %sx%s, nCols x nLines: %sx%s' % [cWidth, cHeight, nCols, nLines])
	onNeedRedraw()


func onNeedRedraw():
	print('onNeedRedraw()')
	redrawNeeded = true
	set_process(true)
	
	
	
func _process(delta):
	print("_process()")
	if cWidth == 0:
		return


	set_process(false)
	redrawNeeded = false
	
	_clear()

	print("iterating children")
	for child in _drawTargets():
		child.tuiDraw(self)
	update()


func _draw():
	print("TUI_Overlay._draw()")
	draw_rect(Rect2(Vector2(), rect_size), Color(0,0,0, .5))

	for linenum in range(nLines):
		var pos = Vector2(0, cHeight*(linenum+1))
		draw_string(font, pos, lines[linenum])


func registerString(owner, string):
	var pos = owner.get_global_position()
	print('pos: ', pos)

	# pos.x -= 20

	var startcol = round(pos.x as float / cWidth) as int
	var startline = round(pos.y as float / cHeight) as int

	var colnum = startcol
	var linenum = startline

	for c in string:
		if c == "\n":
			linenum += 1
			colnum = startcol
			continue
		if colnum >= nCols or linenum >= nLines:
			print("tui drawing offscreen")
			continue
		lines[linenum][colnum] = c
		colnum += 1

	


# var lastPrint = 0
# var time = 0
# const interval = 1

# func _process(delta):

# 	time += delta
# 	if time - lastPrint >= interval:
# 		lastPrint += interval
# 		# print()