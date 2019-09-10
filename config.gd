extends Node


const colWidths_drugs = [100,62,55]
const colWidths_guns = [150,42,55]



var drugsByName
var placesByName
var gunsByName

var placeNamesList


func _ready():
	drugsByName = {}
	placesByName = {}
	gunsByName = {}
	placeNamesList = []
	for drugCfg in drugs:
		drugsByName[drugCfg.drugName] = drugCfg

	for placeCfg in places:
		placesByName[placeCfg.placeName] = placeCfg
		placeNamesList.append(placeCfg.placeName)

	for gunCfg in guns:
		gunsByName[gunCfg.name] = gunCfg





var drugs = [
    structs.DrugConfig.new( "Acid", 1000, 4400, true, false, "The market is flooded with cheap home-made acid!"),
    structs.DrugConfig.new( "Cocaine", 15000, 29000, false, true),
    structs.DrugConfig.new( "Hashish", 480, 1280, true, false, "The Marrakesh Express has arrived!"),
    structs.DrugConfig.new( "Heroin", 5500, 13000, false, true),
    structs.DrugConfig.new( "Ludes", 11, 60, true, false, "Rival drug dealers raided a pharmacy and are selling cheap ludes!"),
    structs.DrugConfig.new( "MDA", 1500, 4400),
    structs.DrugConfig.new( "Opium", 540, 1250, false, true),
    structs.DrugConfig.new( "PCP", 1000, 2500),
    structs.DrugConfig.new( "Peyote", 220, 700),
    structs.DrugConfig.new( "Shrooms", 630, 1300),
    structs.DrugConfig.new( "Speed", 90, 250, false, true),
    structs.DrugConfig.new( "Viagra", 30, 80, true, false),
    structs.DrugConfig.new( "Weed", 315, 890, true, false, "Columbian freighter dusted the Coast Guard! Weed prices have bottomed out!")
]


var places = [
    structs.PlaceConfig.new("Bronx", 7, 13, 10),
    structs.PlaceConfig.new("Ghetto", 8, 13, 5),
    structs.PlaceConfig.new("Central Park", 6, 13, 15),
    structs.PlaceConfig.new("Manhattan", 4, 11, 90),
    structs.PlaceConfig.new("Coney Island", 6, 13, 20),
    structs.PlaceConfig.new("Brooklyn", 4, 12, 70),
    structs.PlaceConfig.new("Queens", 6, 13, 50),
    structs.PlaceConfig.new("Staten Island", 6, 13, 20)
]


var guns = [
    structs.GunConfig.new("Baretta", 3000, 4, 5),
    structs.GunConfig.new(".38 Special", 3500, 4, 9),
    structs.GunConfig.new("Ruger", 2900, 4, 4),
    structs.GunConfig.new("Saturday Night Special", 3100, 4, 7),
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
