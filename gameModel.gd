extends Node

enum State {DRUG_MENU, MSG_QUEUE, LOANSHARK, COP_FIGHT, BANK, GUNSTORE, PUB}


class Stats:
	var cash
	var debt
	var availSpace
	var totalSpace
	var health
	var guns
	var bitches
	var bank
	var day
	var finalDay
	var curPlace

	func _init():
		cash = 2000
		debt = 5500
		availSpace = 100
		totalSpace = 100
		health = 100
		guns = 0
		bitches = 8
		bank = 0
		day = 1
		finalDay = 31
		curPlace = "Bronx"


var _stats

var _curState

var _rng


####################### Drug Menu

var _drugsHerePrices = {}
var _drugsOwnedQuantities = {}

func here(drug):
	return drug in _drugsHerePrices

func price(drug):
	if not drug in _drugsHerePrices:
		return -1
	return _drugsHerePrices[drug]

func canAfford(drug):
	if price(drug) == -1:
		return -1
	return (_stats.cash/price(drug)) as int

func quantity(drug):
	if not drug in _drugsOwnedQuantities:
		return 0
	return _drugsOwnedQuantities[drug]

func mostCanBuy(drug):
	return min(_stats.availSpace, canAfford(drug))

func canBuy(drug, amnt=1):
	return here(drug) and _stats.cash >= amnt*price(drug) and _stats.availSpace >= amnt

func canSell(drug, amnt=1):
	return here(drug) and quantity(drug) >= amnt

func canDrop(drug, amnt=1):
	return not here(drug) and quantity(drug) >= 1

func buy(drug, amnt : int):
	print('buying %s of %s' % [amnt, drug])
	assert(canBuy(drug, amnt))
	_stats.cash -= price(drug)*amnt
	_stats.availSpace -= amnt
	assert(_stats.cash >= 0)
	assert(_stats.availSpace >= 0)
	if not drug in _drugsOwnedQuantities:
		_drugsOwnedQuantities[drug] = 0
	_drugsOwnedQuantities[drug] += amnt
	# emit_signal("updated")

func sell(drug, amnt : int):
	print('sell %s of %s' % [amnt, drug])
	assert(canSell(drug, amnt))
	_stats.cash += price(drug)*amnt
	_drugsOwnedQuantities[drug] -= amnt
	_stats.availSpace += amnt
	assert(_drugsOwnedQuantities[drug] >= 0)
	assert(_stats.availSpace <= _stats.totalSpace)
	if _drugsOwnedQuantities[drug] == 0:
		_drugsOwnedQuantities.erase(drug)
	# emit_signal("updated")

func drop(drug, amnt : int):
	print('drop %s of %s' % [amnt, drug])
	_drugsOwnedQuantities[drug] -= amnt
	_stats.availSpace += amnt
	assert(_drugsOwnedQuantities[drug] >= 0)
	if _drugsOwnedQuantities[drug] == 0:
		_drugsOwnedQuantities.erase(drug)
	# emit_signal("updated")

func _nRandDrugNamesOtherThan(n, except):
	var outputDrugNames = []
#	var possibleDrugNames = config.drugsByName.keys()
	while outputDrugNames.size() < n:
		var i = _rng.randi_range(0, config.drugs.size()-1)
#		var name = possibleDrugNames[i]
		if not config.drugs[i].drugName in outputDrugNames and not config.drugs[i].drugName in except:
			outputDrugNames.append(config.drugs[i].drugName )
	return outputDrugNames

func _nRandSpecialPriceableDrugNames(n):
	var outputDrugNames = []
#	var possibleDrugNames = config.drugsByName.keys()
	while outputDrugNames.size() < n:
		var i = _rng.randi_range(0, config.drugs.size()-1)
#		var name = possibleDrugNames[i]
		if not config.drugs[i].drugName in outputDrugNames and (config.drugs[i].canBeLow or config.drugs[i].canBeHigh):
			outputDrugNames.append(config.drugs[i].drugName)
	return outputDrugNames


func _calcNSpecialPricedDrugs():
	var i = _rng.randi_range(0, 1000)
	if i < 14:
		return 3
	if i < 280:
		return 2
	if i < 700:
		return 1
	return 0



func _setupDrugsHere():
	var numDrugs = _rng.randi_range(config.placesByName[_stats.curPlace].minDrugs, config.placesByName[_stats.curPlace].maxDrugs)
	print("num drugs: ", numDrugs)

	_drugsHerePrices = {}



	for drugName in _nRandSpecialPriceableDrugNames(_calcNSpecialPricedDrugs()):
		var minPrice = config.drugsByName[drugName].minPrice
		var maxPrice = config.drugsByName[drugName].maxPrice
		var price = _rng.randi_range(minPrice, maxPrice)

		print('specical drug price: ', price)

		if config.drugsByName[drugName].canBeLow:
			price /= 4
			_pushMsg(config.drugsByName[drugName].lowString)
		else:
			price *= 4
			if _rng.randi() % 2 == 0:
				_pushMsg("Cops made a big %s bust! Prices are outrageous!" % drugName)
			else:
				_pushMsg("Addicts are buying %s at ridiculous prices!" % drugName)
		_drugsHerePrices[drugName] = price
		print('-> ', price)

	for drugName in _nRandDrugNamesOtherThan(numDrugs - _drugsHerePrices.size(), _drugsHerePrices.keys()):
		print(drugName)
		var minPrice = config.drugsByName[drugName].minPrice
		var maxPrice = config.drugsByName[drugName].maxPrice
		var price = _rng.randi_range(minPrice, maxPrice)
		_drugsHerePrices[drugName] = price



func drugsHere():
	var drugs = []

	for cfgDrug in config.drugs:
		if cfgDrug.drugName in _drugsHerePrices:
			drugs.append(structs.DrugData.new(cfgDrug.drugName, price(cfgDrug.drugName), quantity(cfgDrug.drugName)))

	return drugs


func drugsOwnedAndNotHere():
	var drugs = []

	for cfgDrug in config.drugs:
		if cfgDrug.drugName in _drugsOwnedQuantities and not cfgDrug.drugName in _drugsHerePrices:
			drugs.append(structs.DrugData.new(cfgDrug.drugName, price(cfgDrug.drugName), quantity(cfgDrug.drugName)))

	return drugs


######### Msg Queue



var _queue = []


class MsgChoice:
	var text
	var onYes

	func _init(text, onYes=null):
		self.text = text
		self.onYes = onYes


func _pushMsg(s):
	print("pushMsg('%s')" % s)
	_queue.push_back(MsgChoice.new(s))
	_curState = State.MSG_QUEUE

func _pushChoice(s, onYes):
	_queue.push_back(MsgChoice.new(s, onYes))
	_curState = State.MSG_QUEUE

func isOnMsg():
	return _queue[0].onYes == null

func getMsgText():
	return _queue[0].text

func chooseOkay():
	_queue.pop_front()
	_maybeChangeState()

func chooseYes():
	_queue[0].onYes.call_func()
	_queue.pop_front()
	_maybeChangeState()

func chooseNo():
	_queue.pop_front()
	_maybeChangeState()

func _maybeChangeState():
	if _queue.size() == 0:
		_curState = State.DRUG_MENU






########### General



func _ready():
	reset()

func curState():
	return _curState


func stats():
	return _stats


func reset():
	_stats = Stats.new()
	_curState = State.DRUG_MENU
	_rng = RandomNumberGenerator.new()
	_rng.randomize()


	_pushMsg("Hello.")

	_setupDrugsHere()



func killIt():
	print("killing it")


