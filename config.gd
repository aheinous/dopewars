extends Node


const colWidths = [100,62,55]

var drugsByName
var placesByName

var placeNamesList


func _ready():
	drugsByName = {}
	placesByName = {}
	placeNamesList = []
	for drugCfg in drugs:
		drugsByName[drugCfg.drugName] = drugCfg

	for placeCfg in places:
		placesByName[placeCfg.placeName] = placeCfg
		placeNamesList.append(placeCfg.placeName)





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
    structs.DrugConfig.new( "Viagra", 30, 80, true, false, "viagra cheap"),
    structs.DrugConfig.new( "Weed", 315, 890, true, false, "Columbian freighter dusted the Coast Guard! Weed prices have bottomed out!")
]


var places = [
    structs.PlaceConfig.new("Bronx", 7, 13),
    structs.PlaceConfig.new("Ghetto", 8, 13),
    structs.PlaceConfig.new("Central Park", 6, 13),
    structs.PlaceConfig.new("Manhattan", 4, 11),
    structs.PlaceConfig.new("Coney Island", 6, 13),
    structs.PlaceConfig.new("Brooklyn", 4, 12),
    structs.PlaceConfig.new("Queens", 6, 13),
    structs.PlaceConfig.new("Staten Island", 6, 13)
]