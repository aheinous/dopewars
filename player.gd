extends "character.gd"

var debt := 5500
var availSpace := 100
var totalSpace := 100
var bank := 0
var day := 0
var finalDay := 31
var curPlace := "Bronx"
var copsKilled := 0
var drugQuantities := {}


func _init():
    cash = 2000
    bitches = 8
