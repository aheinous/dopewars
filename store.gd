var _player
var _ownedQuantities = {}
var _availPrices = {}



class StoreItem:
	var itemName : String
	var price : int
	var quantity : int

	func _init(itemName, price, quantity):
		self.itemName = itemName
		self.price = price
		self.quantity = quantity


func _init(player, ownedQuantities, availPrices):
	self._player = player
	self._ownedQuantities = ownedQuantities
	self._availPrices = availPrices


func setAvailPrices(availPrices):
	self._availPrices = availPrices


func isHere(item):
	return item in _availPrices


func price(item):
	if not item in _availPrices:
		return -1
	return _availPrices[item]


func numCanAfford(item):
	if price(item) == -1:
		return 0
	return (_player.cash/price(item)) as int


func haveAny(item):
	return numHave(item) > 0

func numHave(item):
	return _ownedQuantities.get(item, 0)

func numCanBuy(item):
	return min(_player.availSpace, numCanAfford(item))

func canBuy(item, amnt=1):
	return isHere(item) and _player.cash  >= amnt*price(item) and _player.availSpace >= amnt


func canSell(item, amnt=1):
	return isHere(item) and numHave(item) >= amnt

func canDrop(item, amnt=1):
	return not isHere(item) and numHave(item) >= 1

func buy(item, amnt:int):
	print('buying %s of %s' % [amnt, item])
	assert(canBuy(item, amnt))
	_player.cash -= price(item)*amnt
	_player.availSpace -= amnt
	assert(_player.cash >= 0)
	assert(_player.availSpace >= 0)
	if not item in _ownedQuantities:
		_ownedQuantities[item] = 0
	_ownedQuantities[item] += amnt

func receive(item, amnt):
	_player.availSpace -= amnt
	if not item in _ownedQuantities:
		_ownedQuantities[item] = 0
	_ownedQuantities[item] += amnt

func give(item, amnt):
	_player.availSpace += amnt
	_ownedQuantities[item] -= amnt
	if _ownedQuantities[item] == 0:
		_ownedQuantities.erase(item)

func sell(item, amnt : int):
	print('sell %s of %s' % [amnt, item])
	assert(canSell(item, amnt))
	_player.cash += price(item)*amnt
	_ownedQuantities[item] -= amnt
	_player.availSpace += amnt
	assert(_ownedQuantities[item] >= 0)
	assert(_player.availSpace <= _player.totalSpace)
	if _ownedQuantities[item] == 0:
		_ownedQuantities.erase(item)
	# emit_signal("updated")

func drop(item, amnt : int):
	print('drop %s of %s' % [amnt, item])
	give(item, amnt)




func itemsHere(preferedOrder):
	var items = []
	for itemName in preferedOrder:
		if itemName in _availPrices:
			items.append(StoreItem.new(itemName, price(itemName), numHave(itemName)))
	return items


func itemsOwnedAndNotHere(preferedOrder):
	var items = []
	for itemName in preferedOrder:
		if itemName in _ownedQuantities and not itemName in _availPrices:
			items.append(StoreItem.new(itemName, price(itemName), numHave(itemName)))
	return items


