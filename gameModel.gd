extends Node


const Player = preload('player.gd')
const Store = preload('store.gd')



var faithfulToOriginal = true

enum State {DRUG_MENU, MSG_QUEUE, LOANSHARK, COP_FIGHT, BANK, GUNSTORE, PUB, HIGHSCORES}

var _gameFinished = false



var _player : Player
var _curState = State.MSG_QUEUE
var _drugStore : Store
var _gunStore : Store

var _rng


####################### External API


func getCurPlace():
	return _player.curPlace

func getCash():
	return _player.cash

func getNumGuns():
	return _player.numGuns()

func getDebt():
	return _player.debt

func getBitches():
	return _player.bitches

func getAvailSpace():
	return _player.availSpace

func getTotalSpace():
	return _player.totalSpace

func getBank():
	return _player.bank

func getDay():
	return _player.day

func getFinalDay():
	return _player.finalDay

func getHealth():
	return _player.health

func getDrugsHere():
	return _drugStore.itemsHere(config.drugNameList)

func getDrugsOwnedAndNotHere():
	return _drugStore.itemsOwnedAndNotHere(config.drugNameList)

func canBuyDrug(drug):
	return _drugStore.canBuy(drug)

func canSellDrug(drug):
	return _drugStore.canSell(drug)

func canDropDrug(drug):
	return _drugStore.canDrop(drug)

func getDrugPrice(drug):
	return _drugStore.price(drug)

func getNumDrugCanAfford(drug):
	return _drugStore.numCanAfford(drug)

func getMostDrugCanBuy(drug):
	return _drugStore.numCanBuy(drug)

func getNumDrugHave(drug):
	return _drugStore.numHave(drug)

func buyDrug(drug, amnt):
	_drugStore.buy(drug, amnt)

func receiveDrug(drug, amnt):
	_drugStore.receive(drug, amnt)

func giveDrug(drug, amnt):
	_drugStore.give(drug, amnt)

func sellDrug(drug, amnt):
	_drugStore.sell(drug, amnt)

func dropDrug(drug, amnt):
	_drugStore.drop(drug, amnt)

func canBuyGun(gunName):
	return _gunStore.canBuy(gunName)

func canSellGun(gunName):
	return _gunStore.canSell(gunName)

func buyGun(gunName, price=null):
	_gunStore.buy(gunName, 1, price)

func sellGun(gunName):
	_gunStore.sell(gunName, 1)

func getGunsHere():
	return _gunStore.itemsHere(config.gunNameList)

func leaveGunStore():
	_setState(State.DRUG_MENU)

####################### Drug Menu



func _nRandDrugNamesOtherThan(n, except):
	var outputDrugNames = []
#	var possibleDrugNames = config.drugsByName.keys()
	while outputDrugNames.size() < n:
		var i = _rng.randi_range(0, config.drugs.size()-1)
#		var drugName = possibleDrugNames[i]
		if not config.drugs[i].drugName in outputDrugNames and not config.drugs[i].drugName in except:
			outputDrugNames.append(config.drugs[i].drugName )
	return outputDrugNames

func _nRandSpecialPriceableDrugNames(n):
	var outputDrugNames = []
#	var possibleDrugNames = config.drugsByName.keys()
	while outputDrugNames.size() < n:
		var i = _rng.randi_range(0, config.drugs.size()-1)
#		var drugName = possibleDrugNames[i]
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
	var numDrugs = _rng.randi_range(config.placesByName[_player.curPlace].minDrugs,
	config.placesByName[_player.curPlace].maxDrugs)
	var drugPrices = {}

	for drugName in _nRandSpecialPriceableDrugNames(_calcNSpecialPricedDrugs()):
		var minPrice = config.drugsByName[drugName].minPrice
		var maxPrice = config.drugsByName[drugName].maxPrice
		var price = _rng.randi_range(minPrice, maxPrice)


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
		drugPrices[drugName] = price
		# print('-> ', price)

	for drugName in _nRandDrugNamesOtherThan(numDrugs - drugPrices.size(), drugPrices.keys()):
		# print(drugName)
		var minPrice = config.drugsByName[drugName].minPrice
		var maxPrice = config.drugsByName[drugName].maxPrice
		var price = _rng.randi_range(minPrice, maxPrice)
		drugPrices[drugName] = price

	_drugStore.setItems(drugPrices)





func jet(place):
	print("Jetting to ", place)
	if _player.day == _player.finalDay:
		_endGame("Your dealing time is up...")
		return

	_player.curPlace = place
	_player.day += 1
	_player.debt += ((_player.debt / 10) as int)
	_player.bank += ((_player.bank / 20) as int)

	_possibleSaying()
	_possibleCopsOfferOrEvent()

	if place == "Ghetto":
		_pushChoice("Would you like to visit Dan's House of Guns?", funcref(self, "visitGunStore"))
		_pushChoice("Would you like to visit the pub?", funcref(self, "visitPub"))
	elif place == "Bronx":
		if _player.debt > 0:
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
	_maybeMsgQueueState()

func _pushChoice(s, onYes):
	_queue.push_back(MsgChoice.new(s, onYes))
	_maybeMsgQueueState()

func _pushChoiceFront(s, onYes):
	_queue.push_front(MsgChoice.new(s, onYes))
	_maybeMsgQueueState()


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


func _setState(nextState):
	_curState = nextState
	_maybeMsgQueueState()


func _maybeMsgQueueState():
	if _curState == State.DRUG_MENU and _queue.size() >= 1:
		_curState = State.MSG_QUEUE
	elif _curState == State.MSG_QUEUE and _queue.size() == 0:
		if _gameFinished:
			_curState = State.HIGHSCORES
		else:
			_curState = State.DRUG_MENU




########## Pub

func visitPub():
	print("visitPub()")
	var price = _rng.randi_range(config.bitchPrice_low, config.bitchPrice_high)
	_pushChoiceFront( 	"Would you like to hire a bitch for $%s?" % util.toCommaSepStr(price),
						util.Curry.new(self, "buyBitch", [price]) )
	# _curState = State.PUB
	# _setState(State.PUB)


func buyBitch(price):
	print("buyBitch(%s)" % price)
	if _player.cash < price:
		print("insufficent funds")
		return
	_player.cash -= price
	_player.availSpace += 10
	_player.totalSpace += 10
	_player.bitches += 1


########### Loanshark



func visitLoanShark():
	print("visitLoanShark()")
	# _curState = State.LOANSHARK
	_setState(State.LOANSHARK)


func mostCanPayback():
	return min(_player.debt, _player.cash)



func payback(amnt):
	_player.cash -= amnt
	_player.debt -= amnt
	leaveLoanshark()


func leaveLoanshark():
	# _msgQueue_nextState()
	_setState(State.DRUG_MENU)


########### Bank

func visitBank():
	print("visitBank()")
	# _curState = State.BANK
	_setState(State.BANK)


func deposit(amnt):
	_player.cash -= amnt
	_player.bank += amnt
	leaveBank()

func withdraw(amnt):
	_player.cash += amnt
	_player.bank -= amnt
	leaveBank()

func leaveBank():
	_setState(State.DRUG_MENU)


########### Gun Store

# var _gunQuantities

func visitGunStore():
	print("visitGunStore()")
	_setState(State.GUNSTORE)

########### Cop Fight


class CopFight:
	var _cfg
	var numDeputies
	var copHealth = 100
	var fightText = []
	var fightOver = false


	func _init(cfg):
		self._cfg = cfg


func _playerAttackRating(gunCounts):
	var rating = 80
	for gunName in gunCounts.keys():
		rating += config.gunsByName[gunName].damage * gunCounts[gunName]
	return rating


func _playerDefendRating(bitches):
	return 100 - 5 * bitches


func _copAttackRating():
	var gunCounts = _copsGunCounts()
	var rating = _playerAttackRating(_copsGunCounts())
	rating -= fightData._cfg.attackPenalty
	return rating


func _copDefendRating():
	return _playerAttackRating(_copsGunCounts()) - fightData._cfg.defendPenalty


func _copArmour():
	if fightData.numDeputies == 0:
		return fightData._cfg.armour
	else:
		return fightData._cfg.deputyArmour

func _playerArmour():
	if _player.bitches == 0:
		return 100
	else:
		return 50


func _copsAttackPlayer():
	var attackRating = _copAttackRating()
	var defendRating = _playerDefendRating(_player.bitches)
	print("_copsAttackPlayer() %s, %s" % [attackRating, defendRating])
	if _rng.randi_range(0, attackRating-1) > _rng.randi_range(0, defendRating):
		# hit
		var damage = _calcDamage(_copsGunCounts(), _playerArmour())
		var res = _playerTakesDamage(damage)
		var fmt = ""
		match res:
			DamageRes.NONE:
				fmt = "\n%s hits you, man!"
			DamageRes.BITCH_KILLED:
				fmt = "\n%s shoots at you... and kills a bitch!"
			DamageRes.DEAD:
				fmt = "\n%s wasted you, man! What a drag!"
		fightData.fightText[-1] += fmt % fightData._cfg.copName
	else:
		# miss
		fightData.fightText[-1] += "\n%s shoots at you... and misses!" % fightData._cfg.copName


func _playerAttacksCops():
	var attackRating = _playerAttackRating(_player.gunQuantities)
	var defendRating = _copDefendRating()
	print("_playerAttacksCops() %s, %s" % [attackRating, defendRating])
	if _rng.randi_range(0, attackRating-1) > _rng.randi_range(0, defendRating):
		# hit
		var damage = _calcDamage(_player.gunQuantities, _copArmour())
		var res = _copsTakeDamage(damage)
		var fmt = ""
		match res:
			DamageRes.NONE:
				fmt = "You hit %s!"
			DamageRes.DEPUTY_KILLED:
				fmt = "You hit %s and killed a deputy!"
			DamageRes.DEAD:
				fmt = "You killed %s!"
		fightData.fightText.append(fmt % fightData._cfg.copName)
	else:
		# miss
		fightData.fightText.append( "You missed %s!" % fightData._cfg.copName )

	if fightOver():
		if faithfulToOriginal:
			var loot = _rng.randi_range(100, 1999)
			fightData.fightText[-1] += "\nYou find $%s on the body!" % util.toCommaSepStr(loot)
			_player.cash += loot
		else:
			pass # TODO
	else:
		_copsAttackPlayer()





func _calcDamage(gunCounts, armour):
	# print("calc damage: ", gunCounts, ", ", armour)
	var damage = 0
	for gunName in gunCounts:
		var count = gunCounts[gunName]
		for i in range(count):
			damage += _rng.randi_range(0,config.gunsByName[gunName].damage-1)
			# print("d: ", damage )
	damage = (damage * 100 / armour) as int
	damage = max(1, damage)
	return damage



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
		return 'Item:[%s, %s, %s, %s]' % ["GUN" if self.type==ItemType.GUN else "DRUG", self.itemName, self.space, "dropped" if self.dropped else "not dropped"]



func _getInvetoryItemList():
	return [] # TODO
	# var list = []
	# for gunName in _gunQuantities:
	# 	for i in range(_gunQuantities[gunName]):
	# 		list.append(_InvetoryItem.new(ItemType.GUN, gunName, config.gunsByName[gunName].space))
	# for drugName in _drugsOwnedQuantities:
	# 	for i in range(_drugsOwnedQuantities[drugName]):
	# 		list.append(_InvetoryItem.new(ItemType.DRUG, drugName, 1))
	# return list


func _printItemList(items):
	print('item list: [')
	for item in items:
		print('\t', item.toStr())
	print(']')


func _playerLosesBitch():
	pass # TODO
	# var items = _getInvetoryItemList()

	# _printItemList(items)

	# var spaceRecovered = 0
	# while spaceRecovered < 10:
	# 	# chooseRandom item based on size
	# 	var spaceIdx = _rng.randi_range(0, _player.totalSpace)
	# 	if spaceIdx >= (_player.totalSpace - _player.availSpace):
	# 		spaceRecovered += 1
	# 		continue
	# 	var spacePassed = 0
	# 	var itemIdx = 0
	# 	while spacePassed < spaceIdx:
	# 		spacePassed += items[itemIdx].space
	# 		if spacePassed <= spaceIdx:
	# 			itemIdx += 1

	# 	if spaceRecovered + items[itemIdx].space > 10 \
	# 			or items[itemIdx].dropped:
	# 		# cant free more than 10
	# 		# cant drop an item twice
	# 		continue

	# 	# drop item
	# 	if items[itemIdx].type == ItemType.DRUG:
	# 		drop(items[itemIdx].itemName, 1)
	# 		# TODO drop adjacent
	# 	else:
	# 		dropGun(items[itemIdx].itemName)
	# 	spaceRecovered += items[itemIdx].space
	# 	items[itemIdx].dropped = true

	# _player.bitches -= 1
	# _player.totalSpace -= 10
	# _player.availSpace -= 10






enum DamageRes {NONE, BITCH_KILLED, DEPUTY_KILLED, DEAD}

func _playerTakesDamage(amnt):
	print("player taking %s damage" % amnt)
	print("warning: incomplete")
	if _player.health - amnt <= 0:
		if _player.bitches > 0:
			_player.health = 100
			_playerLosesBitch()
			return DamageRes.BITCH_KILLED
		_player.health = 0
		fightData.fightOver = true
		_endGame()
		return DamageRes.DEAD

	_player.health -= amnt
	return DamageRes.NONE


func _copsTakeDamage(amnt):
	print("cops taking %s damange" % amnt)

	if fightData.copHealth - amnt <= 0:
		if fightData.numDeputies > 0:
			fightData.numDeputies -= 1
			fightData.copHealth = 100
			return DamageRes.DEPUTY_KILLED
		fightData.copHealth = 0
		fightData.fightOver = true
		_player.copsKilled += 1
		return DamageRes.DEAD

	fightData.copHealth -= amnt
	return DamageRes.NONE




var fightData




func _copsGunCount():
	return fightData._cfg.copGun + fightData._cfg.deputyGun * fightData.numDeputies

func _copsGunCounts():
	return {config.guns[fightData._cfg.gunIndex].gunName : _copsGunCount()}


func _howArmed():
	var maxDamage = 0
	for gun in config.guns:
		maxDamage = max(maxDamage, gun.damage)
		maxDamage *= (numDeputies()+1)

	var damage = config.guns[fightData._cfg.gunIndex].damage * _copsGunCount()

	var armPercent = 100 * damage / maxDamage

	if armPercent < 10: return "pitifully armed"
	elif armPercent < 25: return "lightly armed"
	elif armPercent < 60: return "moderately well armed"
	elif armPercent < 80: return "heavily armed"
	else: return "armed to the teeth"



func _copFight():
	print("COP FIGHT")
	# _curState = State.COP_FIGHT
	_setState(State.COP_FIGHT)

	fightData = CopFight.new(config.cops[_player.copsKilled])
	fightData.numDeputies = _rng.randi_range(fightData._cfg.minDeputies, fightData._cfg.maxDeputies+1)
	fightData.fightText.append("%s and %s deputies - %s - are chasing you, man!" \
			% [fightData._cfg.copName, fightData.numDeputies, _howArmed()])
	_copsAttackPlayer()


func _visitDoctor(price):
	if _player.cash < price:
		print("insufficent funds")
		return
	_player.cash -= price
	_player.health = 100


func curCop():
	return "Officer Hardass"

func getFightText():
	return fightData.fightText[-1]

func numDeputies():
	return fightData.numDeputies

func canFight():
	return _player.numGuns() > 0

func fightOver():
	return fightData.fightOver

func finishFight():
	print("you chose to FINISH FIGHT.")
	if _gameFinished:
		_setState(State.HIGHSCORES)
	else:
		if _rng.randi_range(0,99) > config.placesByName[_player.curPlace].police and _player.health < 100:
			var randBitchPrice = _rng.randi_range(config.bitchPrice_low, config.bitchPrice_high-1)
			var doctorPrice = randBitchPrice * (100-_player.health) / 500
			_pushChoiceFront("Do you pay a doctor $%s to sew you up?" % util.toCommaSepStr(doctorPrice),
								util.Curry.new(self, '_visitDoctor', [doctorPrice]))
		_setState(State.DRUG_MENU)

func fight():
	print("you chose to FIGHT.")
	_playerAttacksCops()

func stand():
	print("you chose to STAND.")
	fightData.fightText.append("You stand there like a dummy.")
	print(fightData.fightText)
	_copsAttackPlayer()

func run():
	print("you chose to RUN.")
	if _rng.randi_range(0, 99) < 60:
		fightData.fightText.append("You got away!")
		fightData.fightOver = true
	else:
		fightData.fightText.append("Panic! You can't get away!")
		_copsAttackPlayer()


########### General


func gameFinished():
	return _gameFinished

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
		s %= [gun.gunName, util.toCommaSepStr(price)]
		_pushChoice(s, util.Curry.new(self, "buyGun", [gun.gunName, price]))


func _randDrugWithAtLeastAmnt(amnt):
	for i in range(5):
		var drug = _randDrug()
		if _drugStore.numHave(drug) >= amnt:
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
	elif r < 60 and (_drugStore.haveAny("Weed") or _drugStore.haveAny("Hashish")):
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
	_drugStore.give(drug, min(_rng.randi_range(2,5), _drugStore.numHave(drug)))

func _giveOrReceiveDrugs():
	var amnt = _rng.randi_range(3, 6)
	var drug = _randDrugWithAtLeastAmnt(amnt)
	if drug == null and amnt > _player.availSpace:
		return
	elif drug == null:
		drug = _randDrug()
		var fmt = "You meet a friend! He gives you %s %s." if _rng.randi()%2 == 0 else "You find %s %s on a dead dude in the subway."
		_pushMsg(fmt % [amnt, drug])
		_drugStore.receive(drug, amnt)
	else:
		if _rng.randi()%2 == 0:
			var fmt = "You meet a friend! You give him %s %s."
			_pushMsg(fmt % [amnt, drug])
		else:
			var fmt = "Police chased you for %s blocks! You dropped some %s! That's a drag man."
			_pushMsg(fmt % [_rng.randi_range(3,6), drug])
		_drugStore.give(drug, amnt)

func _mugged():
	_pushMsg("You were mugged in the subway!")
	_player.cash = (_player.cash * _rng.randf_range(.8, .95)) as int

func _randElem(list):
	return list[_rng.randi_range(0, list.size()-1)]

func _stopToDoSomething():
	_pushMsg("You stopped to %s." % _randElem(config.stoppedTo))
	_player.cash -= _rng.randi_range(1, min(10, _player.cash))

func _endGame(msg=null):
	print("END GAME: \"%s\"" % msg)
	_clearMsgQueue()
	if msg != null:
		_pushMsg(msg)
	_gameFinished = true
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

	i = _rng.randi_range(0, 79 + config.placesByName[_player.curPlace].police)
	if i < 33:
		_randomOffer()
	elif i < 50:
		_randomEvent()
	else:
		_copFight()


func totalMoney():
	return _player.cash + _player.bank - _player.debt


func _ready():
	reset()

func curState():
	return _curState


func stats():
	return _player


func places():
	return config.placeNameList


func reset():
	_player = Player.new()
	_curState = State.DRUG_MENU
	_gameFinished = false
	_clearMsgQueue()

	_drugStore = Store.new(_player, _player.drugQuantities, {})
	_gunStore = Store.new(_player, _player.gunQuantities, config.gunPrices)

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
	10,
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
