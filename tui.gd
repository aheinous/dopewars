extends Node

const Colors = {	
	"NORMAL":Color(0,1,0),
	"DISABLED" : Color(0.5, 0.5, 0.5),
	"NOT_ACTIVE":Color(0, .3, 0),
	"PRESSED":Color(1, 0, 0)
}

const  DRAW_DEBUG_PATTERN = false

var _overlay = null


var cWidth := 0
var cHeight := 0
var cSize : Vector2
var nCols := 0
var nLines := 0
var dataGrid := []


var minCol = 999999
var maxCol = 0
var minLn = 99999999
var maxLn = 0


var font : Font = load("res://FixedSys24.tres")

var _activeSubtreeStack = []

var _lastPressOwner = null
var _mouseCCoordOwner = null
var _mouseDown = false


class CharData:
	var c : String = " "
	var owner = null
	var fg : Color
	var bg : Color
	var pressable : bool

	func _init(c = " ", owner=null, fg=Colors["NORMAL"], bg=Color(0,0,0), pressable=false):
		self.c = c
		self.owner = owner
		self.fg = fg
		self.bg = bg
		self.pressable = pressable


func _ready():
	cWidth = font.get_string_size("aa").x - font.get_string_size("a").x
	cHeight = font.get_string_size("a").y
	cSize = Vector2(cWidth, cHeight)


func setOverlay(olay):
	_overlay = olay
	_onOlayResized()


func pixelCoordsToCharCoords(pCoords):
	var cCoords = pCoords / cSize
	cCoords.x = cCoords.x as int
	cCoords.y = cCoords.y as int
	if cCoords.x >= nCols or cCoords.y >= nLines or cCoords.x < 0 or cCoords.y < 0:
		return null
	return cCoords


func _onOlayResized():
	nCols = _overlay.rect_size.x / cWidth
	nLines = _overlay.rect_size.y / cHeight
	_clear()
	onNeedRedraw()


func _clear():
	dataGrid = []
	for linenum in range(nLines):
		dataGrid.append([])
		for colnum in range(nCols):
			var fillChar = " "

			var lastLine = nLines-1
			var lastCol = nCols-1

			if DRAW_DEBUG_PATTERN:
				match [linenum, colnum]:
					[0,0]:
						fillChar = "S"
					[lastLine, lastCol]:
						fillChar = "E"
					[_,0]:
						fillChar = "<"
					[_,lastCol]:
						fillChar = ">"
					_:
						fillChar = "."

			dataGrid[-1].append(CharData.new(fillChar))
			

static func _childrenInDrawOrder(root):
	var drawOrder = []
	for child in root.get_children():
		drawOrder.append(child)
		drawOrder += _childrenInDrawOrder(child)
	return drawOrder
		

func _drawableElements():
	var tgts = []
	for child in _childrenInDrawOrder(get_tree().get_root()):
		if child.has_method("tuiDraw"):
			tgts.append(child)
	return tgts


var cnt = 0
func onNeedRedraw():
	cnt += 1
	print(cnt, ': onNeedRedraw()')
	# _redrawNeeded = true
	set_process(true)
			

func _process(delta):
	set_process(false)

	$'/root/Game'.propagate_call("refreshCharSize", [false])
	$'/root/Game'.propagate_call("_onRefresh")
	
	
	_clear()

	for child in _drawableElements():
		child.tuiDraw(self)
	if _overlay != null:
		_overlay.update()


func _getCharOwner(cCoords):
	return null if cCoords == null else dataGrid[cCoords.y][cCoords.x].owner

func _isCoordPressable(cCoords):
	return false if cCoords == null else dataGrid[cCoords.y][cCoords.x].pressable


func _onMousePress(cCoords):
	_mouseDown	= true
	if _isCoordPressable(cCoords):
		_lastPressOwner = _getCharOwner(cCoords)
	else:
		_lastPressOwner = null
	onNeedRedraw()

func _onMouseRelease(cCoords):
	_mouseDown = false
	# var owner = dataGrid[cCoords.y][cCoords.x].owner
	var owner = _getCharOwner(cCoords)
	if owner != null and owner == _lastPressOwner and _inActiveSubtree(owner):
		owner.emit_signal("pressed")
	_lastPressOwner = null
	onNeedRedraw()
	print('(%s, %s) -> (%s, %s)' % [minCol, minLn, maxCol, maxLn])

func _onMouseMove(cCoords):
	# var owner = dataGrid[cCoords.y][cCoords.x].owner
	var owner = _getCharOwner(cCoords)
	if owner != _mouseCCoordOwner:
		_mouseCCoordOwner = owner
		if _mouseDown:
			onNeedRedraw()

func registerElement(elem):
	elem.connect("draw", TUI, "onNeedRedraw") 
	elem.connect("visibility_changed", TUI, "onNeedRedraw") 

func pushActiveSubtree(node):
	if _activeSubtreeStack.size() > 0 and _activeSubtreeStack[-1] == node:
		return
	_activeSubtreeStack.push_back(node)

func popActiveSubtree(node):
	var idx = _activeSubtreeStack.find_last(node)
	assert(idx != -1)
	_activeSubtreeStack.remove(idx)



func _inActiveSubtree(node):
	if _activeSubtreeStack.size() == 0:
		return true
	while true:
		if node == null:
			return false
		if node == _activeSubtreeStack[-1]:
			return true
		node = node.get_parent()

func _isDisabled(node):
	return node.has_method("is_disabled")  and node.is_disabled()


func _isPressable(node):
	if not _inActiveSubtree(node) or _isDisabled(node):
		return false

	for sig in node.get_signal_list():
		if sig.name == "pressed":
			return true

	return false


func drawToTUI(owner, string):
	if not owner.is_visible_in_tree():
		return 

	var pos = owner.get_global_position()

	var startcol = round(pos.x as float / cWidth) as int
	var startline = round(pos.y as float / cHeight) as int

	var colnum = startcol
	var linenum = startline

	_inActiveSubtree(owner)

	var color = Colors["NOT_ACTIVE"]
	if _inActiveSubtree(owner):
		color = Colors["NORMAL"]
	if owner == _lastPressOwner and owner == _mouseCCoordOwner:
		color = Colors["PRESSED"]
	if _isDisabled(owner):
		color = Colors["DISABLED"]

	var pressable = _isPressable(owner)

	# if owner.has_method("get_text"):
	# 	print("text, focus: %s, %s" % [owner.get_text(), owner.has_focus()])

	for c in string:
		if c == "\n":
			linenum += 1
			colnum = startcol
			continue
		if colnum >= 0 and colnum < nCols and linenum >= 0 and linenum < nLines:
			dataGrid[linenum][colnum].c = c
			dataGrid[linenum][colnum].owner = owner
			dataGrid[linenum][colnum].fg = color
			dataGrid[linenum][colnum].pressable = pressable

		if c != " ":
			minCol = min(minCol, colnum)
			minLn = min(minLn, linenum)
			maxCol = max(maxCol, colnum)
			maxLn = max(maxLn, linenum)
			
		colnum += 1


