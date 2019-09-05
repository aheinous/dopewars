extends Node

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
	var damage int

	func init(name, price, space, damage):
		self.name = name
		self.price = price
		self.space = space
		self.damage = damage
