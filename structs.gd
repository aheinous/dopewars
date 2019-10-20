extends Node

class StoreItem:
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
	var name : String
	var price : int
	var space : int
	var damage : int

	func _init(name, price, space, damage):
		self.name = name
		self.price = price
		self.space = space
		self.damage = damage


#   gchar *Name, *DeputyName, *DeputiesName;
#   gint Armour, DeputyArmour;
#   gint AttackPenalty, DefendPenalty;
#   gint MinDeputies, MaxDeputies;
#   gint GunIndex;
#   gint CopGun, DeputyGun;

class CopConfig:
	var name : String
	var armour : int
	var deputyArmour : int
	var attackPenalty : int
	var defendPenalty : int
	var minDeputies : int
	var maxDeputies : int
	var gunIndex : int
	var copGun : int
	var deputyGun : int

	func _init(	name,	\
				armour,	\
				deputyArmour,	\
				attackPenalty,	\
				defendPenalty,	\
				minDeputies,	\
				maxDeputies,	\
				gunIndex,	\
				copGun,	\
				deputyGun):
		self.name = name
		self.armour = armour
		self.deputyArmour = deputyArmour
		self.attackPenalty = attackPenalty
		self.defendPenalty = defendPenalty
		self.minDeputies = minDeputies
		self.maxDeputies = maxDeputies
		self.gunIndex = gunIndex
		self.copGun = copGun
		self.deputyGun = deputyGun

