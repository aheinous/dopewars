extends Node


# const colWidths_drugs = [100,62,55]
# const colWidths_guns = [150,42,55]



const colWidths_chars_drugs = [8, 10, 9]
const colWidths_chars_guns = [22, 7, 9]



var drugsByName
var placesByName
var gunsByName

var gunPrices
var gunSizes

var placeNameList
var drugNameList
var gunNameList


func _ready():
	drugsByName = {}
	placesByName = {}
	gunsByName = {}
	placeNameList = []
	drugNameList = []
	gunPrices = {}
	gunNameList = []
	gunSizes = {}

	for drugCfg in drugs:
		drugsByName[drugCfg.drugName] = drugCfg

	for placeCfg in places:
		placesByName[placeCfg.placeName] = placeCfg
		placeNameList.append(placeCfg.placeName)

	for gunCfg in guns:
		gunsByName[gunCfg.gunName] = gunCfg
		gunPrices[gunCfg.gunName] = gunCfg.price
		gunNameList.append(gunCfg.gunName)
		gunSizes[gunCfg.gunName] = gunCfg.space

	for drug in drugs:
		drugNameList.append(drug.drugName)


func itemSize(item):
	if item in drugsByName:
		return 1
	return gunsByName[item].space


class DrugConfig:
	var drugName : String
	var minPrice : int
	var maxPrice : int
	var canBeLow : bool
	var canBeHigh : bool
	var lowString : String

	func _init(drugName, minPrice, maxPrice, canBeLow=false, canBeHigh=false, lowString=""):
		self.drugName = drugName
		self.minPrice = minPrice
		self.maxPrice = maxPrice
		self.canBeLow = canBeLow
		self.canBeHigh = canBeHigh
		self.lowString = lowString


class PlaceConfig:
	var placeName : String
	var minDrugs : int
	var maxDrugs : int
	var police : int

	func _init(placeName, minDrugs, maxDrugs, police = 0):
		self.placeName = placeName
		self.minDrugs = minDrugs
		self.maxDrugs = maxDrugs
		self.police = police



class GunConfig:
	var gunName : String
	var price : int
	var space : int
	var damage : int
	var splash : bool

	func _init(gunName, price, space, damage, splash = false):
		self.gunName = gunName
		self.price = price
		self.space = space
		self.damage = damage
		self.splash = splash


class CopConfig:
	var copName : String
	var armour : int
	# var deputyArmour : int
	var attackPenalty : int
	var defendPenalty : int
	var minDeputies : int
	var maxDeputies : int
	var gunIndex : int
	var copGun : int
	var deputyGun : int
	var minCash : int
	var maxCash : int

	func _init(	copName,	
				armour,	
				# deputyArmour,	
				attackPenalty,	
				defendPenalty,	
				minDeputies,	
				maxDeputies,	
				gunIndex,	
				copGun,	
				deputyGun,
				minCash,
				maxCash
				):
		self.copName = copName
		self.armour = armour
		# self.deputyArmour = deputyArmour
		self.attackPenalty = attackPenalty
		self.defendPenalty = defendPenalty
		self.minDeputies = minDeputies
		self.maxDeputies = maxDeputies
		self.gunIndex = gunIndex
		self.copGun = copGun
		self.deputyGun = deputyGun
		self.minCash = minCash
		self.maxCash = maxCash






var drugs = [
		DrugConfig.new( "Acid", 1000, 4400, true, false, "The market is flooded with cheap home-made acid!"),
		DrugConfig.new( "Cocaine", 15000, 29000, false, true),
		DrugConfig.new( "Hashish", 480, 1280, true, false, "The Marrakesh Express has arrived!"),
		DrugConfig.new( "Heroin", 5500, 13000, false, true),
		DrugConfig.new( "Ludes", 11, 60, true, false, "Rival drug dealers raided a pharmacy and are selling cheap ludes!"),
		DrugConfig.new( "MDA", 1500, 4400),
		DrugConfig.new( "Opium", 540, 1250, false, true),
		DrugConfig.new( "PCP", 1000, 2500),
		DrugConfig.new( "Peyote", 220, 700),
		DrugConfig.new( "Shrooms", 630, 1300),
		DrugConfig.new( "Speed", 90, 250, false, true),
		DrugConfig.new( "Viagra", 30, 80, true, false),
		DrugConfig.new( "Weed", 315, 890, true, false, "Columbian freighter dusted the Coast Guard! Weed prices have bottomed out!")
]


var places = [
		PlaceConfig.new("Bronx", 7, 13, 10),
		PlaceConfig.new("Ghetto", 8, 13, 5),
		PlaceConfig.new("Central Park", 6, 13, 15),
		PlaceConfig.new("Manhattan", 4, 11, 90),
		PlaceConfig.new("Coney Island", 6, 13, 20),
		PlaceConfig.new("Brooklyn", 4, 12, 70),
		PlaceConfig.new("Queens", 6, 13, 50),
		PlaceConfig.new("Staten Island", 6, 13, 20)
]


var guns = [
		GunConfig.new("Baretta", 3000, 4, 10),
		GunConfig.new(".38 Special", 3500, 4, 18),
		GunConfig.new("Ruger", 2900, 4, 8),
		GunConfig.new("Saturday Night Special", 3100, 4, 14),
		GunConfig.new("Rocket Launcher", 20000, 6, 50, true)
]


var cops = [
	CopConfig.new("Officer Hardass", 3, 30, 30, 2, 8, 0, 1, 1, 1000, 2000),
	CopConfig.new("Officer Bob", 5, 30, 20, 4, 10, 0, 2, 1, 100*1000, 250*1000),
	CopConfig.new("Agent Smith", 20, 20, 20, 6, 18, 1, 3, 2, 5*1000*1000, 7*1000*1000)
]


var subwaySayings = [
	"Wouldn\'t it be funny if everyone suddenly quacked at once?",
	"The Pope was once Jewish, you know",
	"I\'ll bet you have some really interesting dreams",
	"So I think I\'m going to Amsterdam this year",
	"Son, you need a yellow haircut",
	"I think it\'s wonderful what they\'re doing with incense these days",
	"I wasn\'t always a woman, you know",
	"Does your mother know you\'re a dope dealer?",
	"Are you high on something?",
	"Oh, you must be from California",
	"I used to be a hippie, myself",
	"There\'s nothing like having lots of money",
	"You look like an aardvark!",
	"I don\'t believe in Ronald Reagan",
	"Courage!  Bush is a noodle!",
	"Haven\'t I seen you on TV?",
	"I think hemorrhoid commercials are really neat!",
	"We\'re winning the war for drugs!",
	"A day without dope is like night",
	"We only use 20% of our brains, so why not burn out the other 80%",
	"I\'m soliciting contributions for Zombies for Christ",
	"I\'d like to sell you an edible poodle",
	"Winners don\'t do drugs... unless they do",
	"Kill a cop for Christ!",
	"I am the walrus!",
	"Jesus loves you more than you will know",
	"I feel an unaccountable urge to dye my hair blue",
	"Wasn\'t Jane Fonda wonderful in Barbarella?",
	"Just say No... well, maybe... ok, what the hell!",
	"Would you like a jelly baby?",
	"Drugs can be your friend!"
]

var songs = [
	"`Are you Experienced` by Jimi Hendrix",
	"`Cheeba Cheeba` by Tone Loc",
	"`Comin` in to Los Angeles` by Arlo Guthrie",
	"`Commercial` by Spanky and Our Gang",
	"`Late in the Evening` by Paul Simon",
	"`Light Up` by Styx",
	"`Mexico` by Jefferson Airplane",
	"`One toke over the line` by Brewer & Shipley",
	"`The Smokeout` by Shel Silverstein",
	"`White Rabbit` by Jefferson Airplane",
	"`Itchycoo Park` by Small Faces",
	"`White Punks on Dope` by the Tubes",
	"`Legend of a Mind` by the Moody Blues",
	"`Eight Miles High` by the Byrds",
	"`Acapulco Gold` by Riders of the Purple Sage",
	"`Kicks` by Paul Revere & the Raiders",
	"the Nixon tapes",
	"`Legalize It` by Mojo Nixon & Skid Roper)"
]

var stoppedTo = [
	"have a beer",
	"smoke a joint",
	"smoke a cigar",
	"smoke a Djarum",
	"smoke a cigarette"
]


const bitchPrice_low = 50000
const bitchPrice_high = 150000
