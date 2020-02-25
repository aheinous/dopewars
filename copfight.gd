const Player = preload('player.gd')
const Cop = preload('cop.gd')

const AttackRes = Player.AttackRes

var _player : Player
var _cop : Cop
var _fightText = []
var _fightOver = false
var _rng
var _onPlayerDeath

func _init(player, rng, onPlayerDeath):
	self._player = player
	self._rng = rng
	self._onPlayerDeath = onPlayerDeath
	self._cop = Cop.new( config.cops[_player.copsKilled], rng )
	_fightText.append("%s and %s deputies - %s - are chasing you, man!" \
			% [_cop._getName(), _cop.getNumDeputies(), _cop.howArmed()])
	_copsAttackPlayer()


			
func _copsAttackPlayer():
	var res = _cop.attack(_player)
	var fmt = ""
	match res:
		AttackRes.MISS:
			fmt = "\n%s shoots at you... and misses!"
		AttackRes.NONFATAL_HIT:
			fmt = "\n%s hits you, man!"
		AttackRes.ACCOMPLICE_KILLED:
			fmt = "\n%s shoots at you... and kills a bitch!"
		AttackRes.DEAD:
			fmt = "\n%s wasted you, man! What a drag!"
	_fightText[-1] += fmt % _cop._getName()

	if res == AttackRes.DEAD:
		_fightOver = true
		_onPlayerDeath.call_func()



func _playerAttacksCops():
	var res = _player.attack(_cop)
	var fmt = ""
	match res:
		AttackRes.MISS:
			fmt = "You missed %s!"
		AttackRes.NONFATAL_HIT:
			fmt = "You hit %s!"
		AttackRes.ACCOMPLICE_KILLED:
			fmt = "You hit %s and killed a deputy!"
		AttackRes.DEAD:
			fmt = "You killed %s!"
	_fightText.append(fmt % _cop._getName())

	if res == AttackRes.DEAD:
		_fightOver = true
		_player.copsKilled += 1
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
	_copsAttackPlayer()

func run():
	print("you chose to RUN.")
	if _rng.randi_range(0, 99) < 60:
		_fightText.append("You got away!")
		_fightOver = true
	else:
		_fightText.append("Panic! You can't get away!")
		_copsAttackPlayer()
