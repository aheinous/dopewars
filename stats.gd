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

	locationDisp.text = "-- %s --" % gameModel.getCurPlace()
	cashDisp.text = "$" + util.toCommaSepStr(gameModel.getCash())
	gunsDisp.text = str(gameModel.getNumGuns())
	debtDisp.text = "$" + util.toCommaSepStr(gameModel.getDebt())
	bitchesDisp.text = str(gameModel.getBitches())
	spaceDisp.text = str(gameModel.getAvailSpace()) + " / " + str(gameModel.getTotalSpace())
	bankDisp.text = "$" + util.toCommaSepStr(gameModel.getBank())
	healthDisp.text = str(gameModel.getHealth())
	dayDisp.text = str(gameModel.getDay()) + " / " + str(gameModel.getFinalDay())
