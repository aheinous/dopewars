extends Control
onready var list = $VBoxContainer/list
onready var stats = $VBoxContainer/stats

onready var cashDisp =    $VBoxContainer/CenterContainer/stats/cashDisp
onready var gunsDisp =    $VBoxContainer/CenterContainer/stats/gunsDisp
onready var debtDisp =    $VBoxContainer/CenterContainer/stats/debtDisp
onready var bitchesDisp = $VBoxContainer/CenterContainer/stats/bitchesDisp
onready var spaceDisp =   $VBoxContainer/CenterContainer/stats/spaceDisp
onready var bankDisp =    $VBoxContainer/CenterContainer/stats/bankDisp
onready var healthDisp =  $VBoxContainer/CenterContainer/stats/healthDisp
onready var dayDisp =     $VBoxContainer/CenterContainer/stats/dayDisp


class DrugData:
	var name : String
	var price : int
	var quantity : int


	func _init(name, price, quantity):
		self.name = name
		self.price = price
		self.quantity = quantity


class Stats:
	var cash : int
	var guns : int
	var debt : int
	var bitches : int
	var spaceNum : int
	var spaceDenum : int
	var bank : int
	var health : int
	var dayNum : int
	var dayDenum : int


func populateStats(stats):
	cashDisp.text = "$" + str(stats.cash)
	gunsDisp.text = str(stats.guns)
	debtDisp.text = "$" + str(stats.debt)
	bitchesDisp.text = str(stats.bitches)
	spaceDisp.text = str(stats.spaceNum) + " / " + str(stats.spaceDenum)
	bankDisp.text = "$" + str(stats.bank)
	healthDisp.text = str(stats.health)
	dayDisp.text = str(stats.dayNum) + " / " + str(stats.dayDenum)





func _ready():
	var drugs := [	DrugData.new('LSD', 2400, 10),
					DrugData.new('Cocaine', 18223, 3),
					DrugData.new('Heroin', -1, 1)
					]

	var stats := Stats.new()

	stats.cash = 1024
	stats.guns = 0
	stats.debt = 2000
	stats.bitches = 3
	stats.spaceNum = 9
	stats.spaceDenum = 110
	stats.bank = 80000
	stats.health = 100
	stats.dayNum = 0
	stats.dayDenum = 30

	list.populate(drugs)

	populateStats(stats)

