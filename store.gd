var _player
var _ownedQuantities = {}
var _itemPrices = {}



class StoreItem:
	var itemName : String
	var price : int
	var quantity : int
	var enabled : bool

	func _init(itemName, price, quantity, enabled):
		self.itemName = itemName
		self.price = price
		self.quantity = quantity
		self.enabled = enabled



func _init(player, ownedQuantities, itemPrices):
	self._player = player
	self._ownedQuantities = ownedQuantities
	setItems(itemPrices)

func setItems(itemPrices):			
	self._itemPrices = itemPrices


func isHere(item):
	return item in _itemPrices

func price(item):
	if not item in _itemPrices:
		return -1
	return _itemPrices[item]

func numCanAfford(item):
	if price(item) == -1:
		return 0
	return (_player.cash/price(item)) as int

func haveAny(item):
	return numHave(item) > 0

func numHave(item):
	return _ownedQuantities.get(item, 0)

func numCanBuy(item):
	return min((_player.availSpace/config.itemSize(item)) as int, numCanAfford(item))

func canBuy(item, amnt=1):
	return isHere(item) and _player.cash  >= amnt*price(item) and _player.availSpace >= amnt*config.itemSize(item)

func canSell(item, amnt=1):
	return isHere(item) and numHave(item) >= amnt

func canDrop(item, amnt=1):
	return not isHere(item) and numHave(item) >= 1

func buy(item, amnt:int, buyPrice=null):
	if buyPrice == null:
		buyPrice = price(item)
	print('buying %s of %s at %s each' % [amnt, item, buyPrice])
	if amnt == 0:
		return
	if _player.cash < buyPrice*amnt:
		print('insufficeint funds')
		return
	if _player.availSpace < config.itemSize(item)*amnt:
		print('not enough space')
		return
	_player.cash -= buyPrice*amnt
	_player.availSpace -= amnt*config.itemSize(item)
	assert(_player.cash >= 0)
	assert(_player.availSpace >= 0)
	if not item in _ownedQuantities:
		_ownedQuantities[item] = 0
	_ownedQuantities[item] += amnt


func receive(item, amnt):
	_player.availSpace -= amnt * config.itemSize(item)
	if not item in _ownedQuantities:
		_ownedQuantities[item] = 0
	_ownedQuantities[item] += amnt


func give(item, amnt):
	_player.availSpace += amnt * config.itemSize(item)
	_ownedQuantities[item] -= amnt
	if _ownedQuantities[item] == 0:
		_ownedQuantities.erase(item)


func sell(item, amnt : int):
	print('sell %s of %s' % [amnt, item])
	assert(canSell(item, amnt))
	_player.cash += price(item)*amnt
	_ownedQuantities[item] -= amnt
	_player.availSpace += amnt  * config.itemSize(item)
	assert(_ownedQuantities[item] >= 0)
	assert(_player.availSpace <= _player.totalSpace)
	if _ownedQuantities[item] == 0:
		_ownedQuantities.erase(item)


func drop(item, amnt : int):
	print('drop %s of %s' % [amnt, item])
	give(item, amnt)


func itemsHere(preferedOrder):
	var items = []
	for itemName in preferedOrder:
		if itemName in _itemPrices:
			items.append(StoreItem.new(
					itemName, 
					price(itemName), 
					numHave(itemName), 
					canBuy(itemName) or canSell(itemName)
			))
	return items


func itemsOwnedAndNotHere(preferedOrder):
	var items = []
	for itemName in preferedOrder:
		if itemName in _ownedQuantities and not itemName in _itemPrices:
			items.append(StoreItem.new(
					itemName, 
					price(itemName), 
					numHave(itemName), 
					canBuy(itemName) or canSell(itemName)
			))
	return items


