extends Node


# static func slice(arr, start, end):
# 	var res = ""
# 	for i in range(start, end):
# 		res += arr[i]
# 	return res

# static func font_test(font):
# 	var s = "abcdefghijklmnopABCDEFGHJKLMNOPQRSTUVWXYZ01234567890 !@#$%^&*()"
# 	for x in range(1,s.length()):
# 		var s2 = slice(s, 0, x)
# 		print("\"%s\": %s, avg width: %s" % [s2, font.get_string_size(s2), font.get_string_size(s2).x / s2.length()])




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

static func lpad_pixels(font, tgt_width : int, s : String ):
	return _lrpad_spaces(font,tgt_width, s) + s


static func nSpaces(n):
	var s = ""
	for unused in range(n):
		s += " "
	return s


static func lrpad_chars(tgt_width, s):
	var nSpaces = tgt_width - s.length()
	var nRightSpaces = nSpaces/2
	var nLeftSpaces = nSpaces - nRightSpaces
	return nSpaces(nLeftSpaces) + s + nSpaces(nRightSpaces)


static func lpad_chars(tgt_width, s):
	return nSpaces(tgt_width - s.length()) + s

static func rpad_chars(tgt_width, s):
	return s + nSpaces(tgt_width - s.length())


static func lpadColumnStr(font, cols):
	for col in cols:
		var colWidth = 0
		for s in col:
			print(colWidth, ", " ,s,", ", font, ", ",font.get_string_size(s))
			colWidth = max(colWidth, font.get_string_size(s).x)
		for i in range(col.size()):
			col[i] = lpad_pixels(font, colWidth, col[i])

	var output = ""
	for rowIdx in range(cols[0].size()):
		for colIdx in range(cols.size()):
			output += cols[colIdx][rowIdx]
		output += "\n"
	return output


static func centerFill(tgtWidth, left, right):
	return left + nSpaces(tgtWidth-left.length()-right.length()) + right

static func isNAN(x):
	return x != x


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


static func roundUpToMult(x:int, mult:int):
	return ((x + mult - 1) / mult) * mult


static func vec2_roundUpToMult(vx: Vector2, vmult:Vector2):
	var res = Vector2()
	res[0] = roundUpToMult(vx[0], vmult[0])
	res[1] = roundUpToMult(vx[1], vmult[1])
	return res



static func roundToMult(x:int, mult:int):
	return ((x + mult/2) / mult) * mult
	


static func vec2_roundToMult(vx: Vector2, vmult:Vector2):
	var res = Vector2()
	res[0] = roundToMult(vx[0], vmult[0])
	res[1] = roundToMult(vx[1], vmult[1])
	return res


static func _isWhite(c:String):
	assert(c.length() == 1)
	return c == " " or c == "\t" or c == "\n"

static func _split(s):
	var res = []
	var curWord = ""

	for c in s:
		if _isWhite(c):
			if curWord.length() > 0:
				res.append(curWord)
				curWord = ""
			if c == "\n":
				res.append(c)
		else:
			curWord += c
	if curWord.length() > 0:
		res.append(curWord)
	return res
	 

static func wordWrap(s, maxCols):
	var words = _split(s)
	var res = ""
	var curlineLen = 0

	for word in words:
		if word == "\n":
			res += word
			curlineLen = 0
		elif curlineLen + word.length() < maxCols:
			if curlineLen > 0:
				res += " "
				curlineLen += 1
			res += word
			curlineLen += word.length()
		else:
			res += "\n"
			res += word
			curlineLen = word.length()

	return res


static func getCharSize(s):
	var nCols = 0
	var lines = s.split("\n")
	for ln in lines:
		nCols = max(nCols, ln.length())
	return Vector2(nCols, lines.size())

