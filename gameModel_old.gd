extends Node


signal updated
signal msgsAvail
signal choicesAvail

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


var drugsHerePrices
var drugsOwnedQuantities

var rng

var msgs = []


func _ready():
	reset()



func here(drug):
	return drug in drugsHerePrices

func price(drug):
	if not drug in drugsHerePrices:
		return -1
	return drugsHerePrices[drug]



func canAfford(drug):
	if price(drug) == -1:
		return -1
	return (cash/price(drug)) as int

func quantity(drug):
	if not drug in drugsOwnedQuantities:
		return 0
	return drugsOwnedQuantities[drug]

func mostCanBuy(drug):
	return min(availSpace, canAfford(drug))

func canBuy(drug, amnt=1):
	return here(drug) and cash >= amnt*price(drug) and availSpace >= amnt

func canSell(drug, amnt=1):
	return here(drug) and quantity(drug) >= amnt

func canDrop(drug, amnt=1):
	return not here(drug) and quantity(drug) >= 1

func buy(drug, amnt : int):
	print('buying %s of %s' % [amnt, drug])
	assert(canBuy(drug, amnt))
	cash -= price(drug)*amnt
	availSpace -= amnt
	assert(cash >= 0)
	assert(availSpace >= 0)
	if not drug in drugsOwnedQuantities:
		drugsOwnedQuantities[drug] = 0
	drugsOwnedQuantities[drug] += amnt
	emit_signal("updated")

func sell(drug, amnt : int):
	print('sell %s of %s' % [amnt, drug])
	assert(canSell(drug, amnt))
	cash += price(drug)*amnt
	drugsOwnedQuantities[drug] -= amnt
	availSpace += amnt
	assert(drugsOwnedQuantities[drug] >= 0)
	assert(availSpace <= totalSpace)
	if drugsOwnedQuantities[drug] == 0:
		drugsOwnedQuantities.erase(drug)
	emit_signal("updated")

func drop(drug, amnt : int):
	print('drop %s of %s' % [amnt, drug])
	drugsOwnedQuantities[drug] -= amnt
	availSpace += amnt
	assert(drugsOwnedQuantities[drug] >= 0)
	if drugsOwnedQuantities[drug] == 0:
		drugsOwnedQuantities.erase(drug)
	emit_signal("updated")




func reset():
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
	drugsOwnedQuantities = {}

	rng = RandomNumberGenerator.new()
	rng.randomize()
	msgs = []

	setupNewPlace()



func nRandDrugNamesOtherThan(n, except):
	var outputDrugNames = []
#	var possibleDrugNames = config.drugsByName.keys()
	while outputDrugNames.size() < n:
		var i = rng.randi_range(0, config.drugs.size()-1)
#		var name = possibleDrugNames[i]
		if not config.drugs[i].drugName in outputDrugNames and not config.drugs[i].drugName in except:
			outputDrugNames.append(config.drugs[i].drugName )
	return outputDrugNames

func nRandSpecialPriceableDrugNames(n):
	var outputDrugNames = []
#	var possibleDrugNames = config.drugsByName.keys()
	while outputDrugNames.size() < n:
		var i = rng.randi_range(0, config.drugs.size()-1)
#		var name = possibleDrugNames[i]
		if not config.drugs[i].drugName in outputDrugNames and (config.drugs[i].canBeLow or config.drugs[i].canBeHigh):
			outputDrugNames.append(config.drugs[i].drugName)
	return outputDrugNames


func _calcNSpecialPricedDrugs():
	var i = rng.randi_range(0, 1000)
	if i < 14:
		return 3
	if i < 280:
		return 2
	if i < 700:
		return 1
	return 0


func showMsg(s):
	print('msg: "%s"' % s)
	msgs.append(s)

func clearMsgs():
	msgs = []

func setupNewPlace():
	var numDrugs = rng.randi_range(config.placesByName[curPlace].minDrugs, config.placesByName[curPlace].maxDrugs)
	print("num drugs: ", numDrugs)

#	var numSp
	msgs = []
	drugsHerePrices = {}



	for drugName in nRandSpecialPriceableDrugNames(_calcNSpecialPricedDrugs()):
		var minPrice = config.drugsByName[drugName].minPrice
		var maxPrice = config.drugsByName[drugName].maxPrice
		var price = rng.randi_range(minPrice, maxPrice)

		print('speical drug price: ', price)

		if config.drugsByName[drugName].canBeLow:
			price /= 4
			showMsg(config.drugsByName[drugName].lowString)
		else:
			price *= 4
			if rng.randi() % 2 == 0:
				showMsg("Cops made a big %s bust! Prices are outrageous!" % drugName)
			else:
				showMsg("Addicts are buying %s at ridiculous prices!" % drugName)
		drugsHerePrices[drugName] = price
		print('-> ', price)




	for drugName in nRandDrugNamesOtherThan(numDrugs - drugsHerePrices.size(), drugsHerePrices.keys()):
		print(drugName)
		var minPrice = config.drugsByName[drugName].minPrice
		var maxPrice = config.drugsByName[drugName].maxPrice
		var price = rng.randi_range(minPrice, maxPrice)
		drugsHerePrices[drugName] = price

	emit_signal("updated")
	if msgs.size() > 0:
		emit_signal("msgsAvail")




func drugsHereAndOwned():
#	var drugs := [	structs.DrugData.new('Weed', 720, 10),
#					structs.DrugData.new('MDMA', 2400, 10),
#					structs.DrugData.new('Cocaine', 18223, 3),
#					structs.DrugData.new('Heroin', -1, 1)
#					]
#	return drugs

	var drugs = []

#
	for cfgDrug in config.drugs:
		if cfgDrug.drugName in drugsHerePrices:
			drugs.append(structs.DrugData.new(cfgDrug.drugName, price(cfgDrug.drugName), quantity(cfgDrug.drugName)))
	for cfgDrug in config.drugs:
		if cfgDrug.drugName in drugsOwnedQuantities and not cfgDrug.drugName in drugsHerePrices:
			drugs.append(structs.DrugData.new(cfgDrug.drugName, price(cfgDrug.drugName), quantity(cfgDrug.drugName)))

	# for drugName  in drugsHerePrices.keys():
	# 	drugs.append(structs.DrugData.new(drugName, price(drugName), quantity(drugName)))
	# for drugName in drugsOwnedQuantities.keys():
	# 	if not drugName in drugsHerePrices:
	# 		drugs.append(structs.DrugData.new(drugName, price(drugName), quantity(drugName)))
	return drugs


func places():
#	return config.places.keys()
	return config.placeNamesList


func jet(place):
	print("Jetting to ", place)
	curPlace = place
	day += 1
	if place == "Ghetto":
		pushChoice("Would you like to visit Dan's House of Guns?", funcref(self, "visitGunStore"))
		pushChoice("Would you like to visit the pub?", funcref(self, "visitPub"))
	setupNewPlace()



func visitGunStore():
	print("visiting gun store")

func visitPub():
	print("visiting pub")


class Choice:
	var desc
	var onYes

	func _init(desc, onYes):
		self.desc = desc
		self.onYes = onYes



var choiceQueue = []


func isChoiceAvail():
	return choiceQueue.size() > 0

func curChoiceDesc():
	return choiceQueue[0].desc

func chooseYes():
	choiceQueue[0].onYes.call_func()
	choiceQueue.pop_front()

func chooseNo():
	choiceQueue.pop_front()

func pushChoice(desc, onYes):
	choiceQueue.push_back(Choice.new(desc, onYes))
	emit_signal("choicesAvail")

