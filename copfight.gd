const Player = preload('player.gd')
const Cop = preload('cop.gd')

const MoveRes = Player.MoveRes

var _player : Player
var _cop : Cop
var _fightText = []
var _fightOver = false
var _rng
var _onPlayerDeath
var _turnRes = []

func _init(player, rng, onPlayerDeath):
	self._player = player
	self._rng = rng
	self._onPlayerDeath = onPlayerDeath
	self._cop = Cop.new( config.cops[_player.copsKilled], rng )
	_fightText.append("%s and %s deputies - %s - are chasing you, man!" \
			% [_cop._getName(), _cop.getNumDeputies(), _cop.howArmed()])
	_turnRes = [MoveRes.NONE]
	_copsAttackPlayer()


			
func _copsAttackPlayer():
	var res = _cop.attack(_player)
	var fmt = ""
	match res:
		MoveRes.MISS:
			fmt = "\n%s shoots at you... and misses!"
		MoveRes.NONFATAL_HIT:
			fmt = "\n%s hits you, man!"
		MoveRes.ACCOMPLICE_KILLED:
			fmt = "\n%s shoots at you... and kills a bitch!"
		MoveRes.DEAD:
			fmt = "\n%s wasted you, man! What a drag!"
		_:
			assert(false)
	_fightText[-1] += fmt % _cop._getName()
	_turnRes.append(res)

	if res == MoveRes.DEAD:
		_fightOver = true
		_onPlayerDeath.call_func()



func _playerAttacksCops():
	var res = _player.attack(_cop)
	var fmt = ""
	match res:
		MoveRes.MISS:
			fmt = "You missed %s!"
		MoveRes.NONFATAL_HIT:
			fmt = "You hit %s!"
		MoveRes.ACCOMPLICE_KILLED:
			fmt = "You hit %s and killed a deputy!"
		MoveRes.DEAD:
			fmt = "You killed %s!"
		_:
			assert(false)
	_fightText.append(fmt % _cop._getName())
	_turnRes = [res]

	if res == MoveRes.DEAD:
		_fightOver = true
		_player.copsKilled += 1
		_turnRes.append(MoveRes.NONE)
	else:
		_copsAttackPlayer()


# Queries

func curCop():
	return _cop._getName()

func getFightText():
	return _fightText[-1]

func numDeputies():
	return _cop.getNumDeputies()

func canFight():
	return _player.numGuns() > 0

func fightOver():
	return _fightOver

func copHealth():
	return _cop.health

func getTurnRes():
	return _turnRes

# Actions

# func finishFight():
# 	pass
# 	# print("you chose to FINISH FIGHT.")
# 	# if _gameFinished:
# 	# 	_setState(State.HIGHSCORES)
# 	# else:
# 	# 	if _rng.randi_range(0,99) > config.placesByName[_player.curPlace].police and _player.health < 100:
# 	# 		var randBitchPrice = _rng.randi_range(config.bitchPrice_low, config.bitchPrice_high-1)
# 	# 		var doctorPrice = randBitchPrice * (100-_player.health) / 500
# 	# 		_pushChoiceFront("Do you pay a doctor $%s to sew you up?" % util.toCommaSepStr(doctorPrice),
# 	# 							util.Curry.new(self, '_visitDoctor', [doctorPrice]))
# 	# 	_setState(State.DRUG_MENU)

func fight():
	print("you chose to FIGHT.")
	_playerAttacksCops()

func stand():
	print("you chose to STAND.")
	_fightText.append("You stand there like a dummy.")
	# print(_fightText)
	_turnRes = [MoveRes.STAND]
	_copsAttackPlayer()

func run():
	print("you chose to RUN.")
	if _rng.randi_range(0, 99) < 60:
		_fightText.append("You got away!")
		_fightOver = true
		_turnRes = [MoveRes.ESCAPE, MoveRes.NONE]
	else:
		_fightText.append("Panic! You can't get away!")
		_turnRes = [MoveRes.FAILED_ESCAPE]
		_copsAttackPlayer()
