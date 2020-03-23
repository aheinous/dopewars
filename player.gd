extends "character.gd"

var debt := 5500
var availSpace := 100
var totalSpace := 100
var bank := 0
var day := 1
var finalDay := 31
var curPlace := "Bronx"
var copsKilled := 0
var drugCounts := {}


func _init(rng):
	self.rng = rng
	cash = 2000
	numAccomplices = 8

func _getName():
	return "player"

func getNumBitches():
	return numAccomplices



enum ItemType {GUN, DRUG}

class _InvetoryItem:
	var type
	var itemName
	var space
	var dropped

	func _init(type, itemName, space):
		self.type = type
		self.itemName = itemName
		self.space = space
		self.dropped = false

	func toStr():
		return 'Item:[%s, %s, %s, %s]' % [
			"GUN" if self.type==ItemType.GUN else "DRUG", 
			self.itemName, 
			self.space, 
			"dropped" if self.dropped else "not dropped"
		]


	func drop(player):
		var counts = player.gunCounts if type == ItemType.GUN else player.drugCounts
		counts[itemName] -= 1
		if counts[itemName] == 0:
			counts.erase(itemName)		
		player.availSpace += space
		self.dropped = true
			



func _getInvetoryItemList():
	var list = []
	for gunName in gunCounts:
		for i in range(gunCounts[gunName]):
			list.append(_InvetoryItem.new(ItemType.GUN, gunName, config.gunsByName[gunName].space))
	for drugName in drugCounts:
		for i in range(drugCounts[drugName]):
			list.append(_InvetoryItem.new(ItemType.DRUG, drugName, 1))
	return list
	

func _printItemList(items):
	print('item list: [')
	for item in items:
		print('\t', item.toStr())
	print(']')
	
	
func _onAccompliceKilled():
	var items = _getInvetoryItemList()
	_printItemList(items)

	var spaceRecovered = 0
	while spaceRecovered < 10:
		# chooseRandom item based on size
		var spaceIdx = rng.randi_range(0, totalSpace)
		if spaceIdx >= (totalSpace - availSpace):
			spaceRecovered += 1
			continue
		var spacePassed = 0
		var itemIdx = 0
		while spacePassed < spaceIdx:
			spacePassed += items[itemIdx].space
			if spacePassed <= spaceIdx:
				itemIdx += 1

		if spaceRecovered + items[itemIdx].space > 10 \
				or items[itemIdx].dropped:
			# cant free more than 10
			# cant drop an item twice
			continue

		# drop item
		items[itemIdx].drop(self)
		spaceRecovered += items[itemIdx].space


	totalSpace -= 10
	availSpace -= 10
