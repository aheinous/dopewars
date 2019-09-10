extends CenterContainer


onready var locationDisp = $VBoxContainer/locationLbl

onready var cashDisp =    $VBoxContainer/GridContainer/cashDisp
onready var gunsDisp =    $VBoxContainer/GridContainer/gunsDisp
onready var debtDisp =    $VBoxContainer/GridContainer/debtDisp
onready var bitchesDisp = $VBoxContainer/GridContainer/bitchesDisp
onready var spaceDisp =   $VBoxContainer/GridContainer/spaceDisp
onready var bankDisp =    $VBoxContainer/GridContainer/bankDisp
onready var healthDisp =  $VBoxContainer/GridContainer/healthDisp
onready var dayDisp =     $VBoxContainer/GridContainer/dayDisp

func populate():

	var stats = gameModel.stats()
	locationDisp.text = "-- %s --" % stats.curPlace
	cashDisp.text = "$" + util.toCommaSepStr(stats.cash)
	gunsDisp.text = str(stats.guns)
	debtDisp.text = "$" + util.toCommaSepStr(stats.debt)
	bitchesDisp.text = str(stats.bitches)
	spaceDisp.text = str(stats.availSpace) + " / " + str(stats.totalSpace)
	bankDisp.text = "$" + util.toCommaSepStr(stats.bank)
	healthDisp.text = str(stats.health)
	dayDisp.text = str(stats.day) + " / " + str(stats.finalDay)
