extends Node

static func _lrpad_spaces(font, tgt_width, s):
	var space = " "
	var s_width = font.get_string_size(s).x
	var space_width = font.get_string_size(space).x
	var nSpace = int(round(((tgt_width-s_width)/space_width)))
	if nSpace < 0:
		print("cant lrpad good")
		return ""
	var out = ""
	for i in range(nSpace):
		out += space
	return out

static func rpad_pixels(font, tgt_width, s):
	return s + _lrpad_spaces(font,tgt_width, s)

static func lpad_pixels(font, tgt_width, s):
	return _lrpad_spaces(font,tgt_width, s) + s


