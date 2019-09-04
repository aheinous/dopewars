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

static func toCommaSepStr(number):
    var string = str(number)
    var mod = string.length() % 3
    var res = ""

    for i in range(0, string.length()):
        if i != 0 && i % 3 == mod:
            res += ","
        res += string[i]

    return res


class Curry:
	var obj
	var funcName
	var args

	func _init(obj, funcName, args):
		self.obj = obj
		self.funcName = funcName
		self.args = args

	func call_func():
		obj.callv(funcName, args)
