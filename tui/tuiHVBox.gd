extends "res://tui/tuiElement.gd"

enum AlignMode {ALIGN_BEGIN, ALIGN_CENTER, ALIGN_END}
export (AlignMode) var alignment = AlignMode.ALIGN_BEGIN

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
	



func _onRefresh():
	if get_path() as String == "/root/Game/MarginContainer/tuiVBox":
		print('here')
	print(get_path())
	
	refreshCharSize(false)

	var szNeeded = _hvVector(getMinCharSize())
	var selfSize = _hvVector(charSize)


	var start = 0
	match alignment:
		AlignMode.ALIGN_BEGIN:
			start = 0
		AlignMode.ALIGN_CENTER:
			start = max(0, selfSize.packedDir/2 - szNeeded.packedDir/2)
		AlignMode.ALIGN_END:
			start = max(0, selfSize.packedDir - szNeeded.packedDir)

	var pos = _hvVector()
	pos.packedDir = start
	for child in get_children():
		child.setCharPos(pos.vec2())
		if _orientation == HORIZONTAL:
			child.setCharHeight(selfSize.tanDir)
		else:
			child.setCharWidth(selfSize.tanDir)
		pos.packedDir += _hvVector(child.charSize).packedDir

		

func getMinCharSize():
	var minSz = _hvVector()
	for child in get_children():
		var childSz = _hvVector(child.getMinCharSize())
		minSz.tanDir = max(minSz.tanDir, childSz.tanDir)
		minSz.packedDir += childSz.packedDir
	return minSz.vec2()
