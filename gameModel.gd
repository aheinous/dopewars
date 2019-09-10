extends Node


enum State {DRUG_MENU, MSG_QUEUE, LOANSHARK, COP_FIGHT, BANK, GUNSTORE, PUB, HIGHSCORES}

var _finished = false

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

var _drugsHerePrices
var _drugsOwnedQuantities

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
	return _drugsOwnedQuantities.get(drug, 0)

func mostCanBuy(drug):
	return min(_stats.availSpace, canAfford(drug))

func canBuy(drug, amnt=1):
	return here(drug) and _stats.cash >= amnt*price(drug) and _stats.availSpace >= amnt

func canSell(drug, amnt=1):
	return here(drug) and quantity(drug) >= amnt

func canDrop(drug, amnt=1):
	return not here(drug) and quantity(drug) >= 1

func buy(drug, amnt:int):
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

func _receive(drug, amnt):
	_stats.availSpace -= amnt
	if not drug in _drugsOwnedQuantities:
		_drugsOwnedQuantities[drug] = 0
	_drugsOwnedQuantities[drug] += amnt

func _give(drug, amnt):
	_stats.availSpace += amnt
	_drugsOwnedQuantities[drug] -= amnt
	if _drugsOwnedQuantities[drug] == 0:
		_drugsOwnedQuantities.erase(drug)

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
	_give(drug, amnt)

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
	_drugsHerePrices = {}

	for drugName in _nRandSpecialPriceableDrugNames(_calcNSpecialPricedDrugs()):
		var minPrice = config.drugsByName[drugName].minPrice
		var maxPrice = config.drugsByName[drugName].maxPrice
		var price = _rng.randi_range(minPrice, maxPrice)

		# print('specical drug price: ', price)

		if config.drugsByName[drugName].canBeLow:
			price /= 4
			if config.drugsByName[drugName].lowString != "":
				_pushMsg(config.drugsByName[drugName].lowString)
		else:
			price *= 4
			if _rng.randi() % 2 == 0:
				_pushMsg("Cops made a big %s bust! Prices are outrageous!" % drugName)
			else:
				_pushMsg("Addicts are buying %s at ridiculous prices!" % drugName)
		_drugsHerePrices[drugName] = price
		# print('-> ', price)

	for drugName in _nRandDrugNamesOtherThan(numDrugs - _drugsHerePrices.size(), _drugsHerePrices.keys()):
		# print(drugName)
		var minPrice = config.drugsByName[drugName].minPrice
		var maxPrice = config.drugsByName[drugName].maxPrice
		var price = _rng.randi_range(minPrice, maxPrice)
		_drugsHerePrices[drugName] = price



func drugsHere():
	var drugs = []

	for cfgDrug in config.drugs:
		if cfgDrug.drugName in _drugsHerePrices:
			drugs.append(structs.StoreItem.new(cfgDrug.drugName, price(cfgDrug.drugName), quantity(cfgDrug.drugName)))

	return drugs


func drugsOwnedAndNotHere():
	var drugs = []

	for cfgDrug in config.drugs:
		if cfgDrug.drugName in _drugsOwnedQuantities and not cfgDrug.drugName in _drugsHerePrices:
			drugs.append(structs.StoreItem.new(cfgDrug.drugName, price(cfgDrug.drugName), quantity(cfgDrug.drugName)))

	return drugs



func jet(place):
	print("Jetting to ", place)
	if _stats.day == _stats.finalDay:
		_endGame("Your dealing time is up...")
		return

	_stats.curPlace = place
	_stats.day += 1
	_stats.debt += ((_stats.debt / 10) as int)
	_stats.bank += ((_stats.bank / 20) as int)

	_possibleSaying()
	_possibleCopsOfferOrEvent()

	if place == "Ghetto":
		_pushChoice("Would you like to visit Dan's House of Guns?", funcref(self, "visitGunStore"))
		_pushChoice("Would you like to visit the pub?", funcref(self, "visitPub"))
	elif place == "Bronx":
		_pushChoice("Would you like to visit the loan shark?", funcref(self, "visitLoanShark"))
		_pushChoice("Would you like to visit the bank?", funcref(self, "visitBank"))
	_setupDrugsHere()


######### Msg Queue



var _queue


class MsgChoice:
	var text
	var onYes

	func _init(text, onYes=null):
		self.text = text
		self.onYes = onYes

func _clearMsgQueue():
	_queue = []

func _pushMsg(s):
	print("pushMsg('%s')" % s)
	_queue.push_back(MsgChoice.new(s))
	_curState = State.MSG_QUEUE

func _pushChoice(s, onYes):
	_queue.push_back(MsgChoice.new(s, onYes))
	_curState = State.MSG_QUEUE

func _pushChoiceFront(s, onYes):
	_queue.push_front(MsgChoice.new(s, onYes))
	_curState = State.MSG_QUEUE



func isOnMsg():
	return _queue[0].onYes == null

func getMsgText():
	return _queue[0].text

func chooseOkay():
	_queue.pop_front()
	_maybeMsgQueueState()

func chooseYes():
	var onYes = _queue.pop_front().onYes
	_maybeMsgQueueState()
	onYes.call_func()


func chooseNo():
	_queue.pop_front()
	_maybeMsgQueueState()

func _maybeMsgQueueState():
	if _queue.size() == 0:
		_curState = State.DRUG_MENU if not _finished else State.HIGHSCORES
	else:
		_curState = State.MSG_QUEUE


########## Pub

func visitPub():
	print("visitPub()")
	var price = _rng.randi_range(config.bitchPrice_low, config.bitchPrice_high)
	_pushChoiceFront( 	"Would you like to hire a bitch for $%s?" % util.toCommaSepStr(price),
						util.Curry.new(self, "buyBitch", [price]) )
	_curState = State.PUB


func buyBitch(price):
	print("buyBitch(%s)" % price)
	if _stats.cash < price:
		print("insufficent funds")
		return
	_stats.cash -= price
	_stats.availSpace += 10
	_stats.totalSpace += 10
	_stats.bitches += 1


########### Loanshark



func visitLoanShark():
	print("visitLoanShark()")
	_curState = State.LOANSHARK


func mostCanPayback():
	return min(_stats.debt, _stats.cash)



func payback(amnt):
	_stats.cash -= amnt
	_stats.debt -= amnt
	leaveLoanshark()


func leaveLoanshark():
	_maybeMsgQueueState()


########### Bank

func visitBank():
	print("visitBank()")
	_curState = State.BANK


func deposit(amnt):
	_stats.cash -= amnt
	_stats.bank += amnt
	leaveBank()

func withdraw(amnt):
	_stats.cash += amnt
	_stats.bank -= amnt
	leaveBank()

func leaveBank():
	_maybeMsgQueueState()


########### Gun Store

var _gunQuantities

func visitGunStore():
	print("visitGunStore()")
	_curState = State.GUNSTORE


func leaveGunStore():
	_maybeMsgQueueState()

func guns():
	var items = []
	for gun in config.guns:
		items.append(structs.StoreItem.new(gun.name, gun.price, _gunQuantities.get(gun.name, 0)))
	return items

func canBuyGun(name):
	return config.gunsByName[name].price <= _stats.cash and config.gunsByName[name].space <= _stats.availSpace

func canSellGun(name):
	return _gunQuantities.get(name, 0) > 0


func buyGun(name, price=null):
	if price == null:
		price = config.gunsByName[name].price
	_gunQuantities[name] = _gunQuantities.get(name, 0) + 1
	_stats.cash -= price
	_stats.availSpace -= config.gunsByName[name].space

func sellGun(name):
	_gunQuantities[name] -= 1
	_stats.cash += config.gunsByName[name].price
	_stats.availSpace += config.gunsByName[name].space

########### Cop Fight

func _copFight():
	print("COP FIGHT!!")


########### General


func _possibleSaying():
	if _rng.randi_range(0, 99) < 15:
		if _rng.randi() % 2 == 0:
			var s = "The lady next to you on the subway said,\n"
			s += "\"%s\"\n(at least, you -think- that's what she said)"
			s = s % config.subwaySayings[_rng.randi_range(0, config.subwaySayings.size()-1)]
			_pushMsg(s)
		else:
			var s = "You hear someone playing %s"
			s = s % config.songs[_rng.randi_range(0, config.songs.size()-1)]
			_pushMsg(s)


func _randomOffer():
	print("_randomOffer()")
	if _rng.randi() % 2 == 0:
		print("offer bitch")
		var price = (_rng.randi_range(config.bitchPrice_low, config.bitchPrice_high) / 10) as int
		var s = "Hey dude! I'll help carry your drugs for a mere $%s. Yes or no?"
		s %= util.toCommaSepStr(price)
		_pushChoice(s, util.Curry.new(self, "buyBitch", [price]))
	else:
		print("offer gun")
		var gun = config.guns[_rng.randi_range(0, config.guns.size()-1)]
		var price = gun.price / 10
		var s = "Would you like to buy a %s for $%s?"
		s %= [gun.name, util.toCommaSepStr(price)]
		_pushChoice(s, util.Curry.new(self, "buyGun", [gun.name, price]))


func _randDrugWithAtLeastAmnt(amnt):
	for i in range(5):
		var drug = _randDrug()
		if quantity(drug) >= amnt:
			return drug
	return null

func _randDrug():
	return _randElem(config.drugs).drugName



func _randomEvent():
	print("_randomEvent()")
	var r = _rng.randi_range(0,99)
	if r < 10:
		_mugged()
	elif r < 50:
		_giveOrReceiveDrugs()
	elif r < 60 and ("Weed" in _drugsOwnedQuantities or "Hashish" in _drugsOwnedQuantities):
		_brownies()
	elif r < 65:
		_paraquatWeed()
	else:
		_stopToDoSomething()


func _paraquatWeed():
	var s = "There is some weed that smells like paraquat here!\nIt looks good! Will you smoke it?"
	var cb = util.Curry.new(self, "_endGame",["You hallucinated for three days on the wildest trip you ever imagined!\nThen you died because your brain disintegrated!"])
	_pushChoice(s, cb)


func _brownies():
	var drug = "Weed" if quantity("Weed") > quantity("Hashish") else "Hashish"
	_pushMsg("Your mama made brownies with some of your %s! They were great!" % drug)
	_give(drug, min(_rng.randi_range(2,5), _drugsOwnedQuantities[drug]))

func _giveOrReceiveDrugs():
	var amnt = _rng.randi_range(3, 6)
	var drug = _randDrugWithAtLeastAmnt(amnt)
	if drug == null and amnt > _stats.availSpace:
		return
	elif drug == null:
		drug = _randDrug()
		var fmt = "You meet a friend! He gives you %s %s." if _rng.randi()%2 == 0 else "You find %s %s on a dead dude in the subway."
		_pushMsg(fmt % [amnt, drug])
		_receive(drug, amnt)
	else:
		if _rng.randi()%2 == 0:
			var fmt = "You meet a friend! You give him %s %s."
			_pushMsg(fmt % [amnt, drug])
		else:
			var fmt = "Police chased you for %s blocks! You dropped some %s! That's a drag man."
			_pushMsg(fmt % [_rng.randi_range(3,6), drug])
		_give(drug, amnt)

func _mugged():
	_pushMsg("You were mugged in the subway!")
	_stats.cash = (_stats.cash * _rng.randf_range(.8, .95)) as int

func _randElem(list):
	return list[_rng.randi_range(0, list.size()-1)]

func _stopToDoSomething():
	_pushMsg("You stopped to %s." % _randElem(config.stoppedTo))
	_stats.cash -= _rng.randi_range(1, min(10, _stats.cash))

func _endGame(msg):
	print("END GAME: \"%s\"" % msg)
	_clearMsgQueue()
	_pushMsg(msg)
	_finished = true
	_addHighscore(totalMoney())



func _possibleCopsOfferOrEvent():
	print("_possibleCopsOfferOrEvent()")

	var i = 99
	if totalMoney() >   3000000:
		i = 129
	elif totalMoney() > 1000000:
		i = 114
	if _rng.randi_range(0,i) <= 75:
		return

	i = _rng.randi_range(0, 79 + config.placesByName[_stats.curPlace].police)
	if i < 33:
		_randomOffer()
	elif i < 50:
		_randomEvent()
	else:
		_copFight()


func totalMoney():
	return _stats.cash + _stats.bank - _stats.debt


func _ready():
	reset()

func curState():
	return _curState


func stats():
	return _stats


func places():
	return config.placeNamesList


func reset():
	_stats = Stats.new()
	_curState = State.DRUG_MENU
	_finished = false
	_clearMsgQueue()
	_gunQuantities = {}
	_drugsHerePrices = {}
	_drugsOwnedQuantities = {}

	_rng = RandomNumberGenerator.new()
	_rng.randomize()
	_setupDrugsHere()



var highscores = [
	10000000,
	1000000,
	100000,
	10000,
	1000,
	100,
	1,

]
var highscoreIndex = -1


func _insertScoreAt(i, score):
	highscores.insert(i, score)
	highscoreIndex = i
	printHighscores()

func _addHighscore(score):
	if highscores.size() == 0:
		_insertScoreAt(0, score)
		return
	for i in range(highscores.size()-1):
		if score >= highscores[i]:
			_insertScoreAt(i, score)
			return
	_insertScoreAt(highscores.size()-1, score)


func printHighscores():
	print("HIGHSCORES:")
	for i in range(highscores.size()-1):
		print("\t%s %10s" % ["*" if i==highscoreIndex else " ", highscores[i]])
