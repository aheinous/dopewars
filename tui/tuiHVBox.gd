extends "res://tui/tuiElement.gd"

enum AlignMode {ALIGN_BEGIN, ALIGN_CENTER, ALIGN_END, ALIGN_SPREAD}
export (AlignMode) var alignment = AlignMode.ALIGN_BEGIN
export (int) var spacing = 0

var _orientation = HORIZONTAL


	

class HorizontalVector:
	var packedDir : int
	var tanDir : int

	func _init(vec : Vector2):
		packedDir = vec.x
		tanDir = vec.y

	func vec2():
		return Vector2(packedDir, tanDir)
	


class VerticalVector:
	var packedDir : int
	var tanDir : int

	func _init(vec : Vector2):
		packedDir = vec.y
		tanDir = vec.x

	func vec2():
		return Vector2(tanDir, packedDir)
		
	
func _hvVector(vec : Vector2 = Vector2()):
	return HorizontalVector.new(vec) if _orientation == HORIZONTAL else VerticalVector.new(vec)
	



func _ready():
	for child in get_children():
		child.connect("charSizeChanged", self, "_onChildCharSizeChanged")
	


func add_child(child, legible_unique_name: bool =false):
	child.connect("charSizeChanged", self, "_onChildCharSizeChanged")
	.add_child(child, legible_unique_name)


func _onChildCharSizeChanged():
	_onRefresh()



func _onRefresh():
	refreshCharSize(false)

	var szNeeded = _hvVector(getMinCharSize())
	var selfSize = _hvVector(charSize)


	var start = 0
	match alignment:
		AlignMode.ALIGN_BEGIN, AlignMode.ALIGN_SPREAD:
			start = 0
		AlignMode.ALIGN_CENTER:
			start = max(0, selfSize.packedDir/2 - szNeeded.packedDir/2)
		AlignMode.ALIGN_END:
			start = max(0, selfSize.packedDir - szNeeded.packedDir)

	var activeChildren = _getActiveChildren()

	var spacing = self.spacing
	var extraSpacingLeftOver = 0
	if alignment == AlignMode.ALIGN_SPREAD:
		spacing = ((selfSize.packedDir - szNeeded.packedDir) / (activeChildren.size() - 1)) as int
		extraSpacingLeftOver = ((selfSize.packedDir - szNeeded.packedDir) % (activeChildren.size() - 1))

		
	var pos = _hvVector()
	pos.packedDir = start
		
	for child in activeChildren:
		child.setCharPos(pos.vec2())
		if _orientation == HORIZONTAL:
			child.setCharHeight(selfSize.tanDir)
		else:
			child.setCharWidth(selfSize.tanDir)
		pos.packedDir += _hvVector(child.charSize).packedDir
		pos.packedDir += spacing
		if extraSpacingLeftOver > 0:
			pos.packedDir += 1
			extraSpacingLeftOver -= 1

	
func _getActiveChildren():
	var ac = []
	for child in get_children():
		if child.is_queued_for_deletion():
			continue
		if not child.is_visible_in_tree():
			continue
		ac.append(child)
	return ac


func getMinCharSize():
	var minSz = _hvVector()
	var first = true

	for child in _getActiveChildren():
		if first:
			first = false
		else:
			minSz.packedDir += spacing
		var childSz = _hvVector(child.getMinCharSize())
		minSz.tanDir = max(minSz.tanDir, childSz.tanDir)
		minSz.packedDir += childSz.packedDir
	return minSz.vec2()
