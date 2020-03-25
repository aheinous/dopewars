extends "character.gd"

var cfg
# var rng

func _init(cfg, rng):
	self.cfg = cfg
	self.rng = rng
	numAccomplices = rng.randi_range(cfg.minDeputies, cfg.maxDeputies+1)

	var gunCount = cfg.copGun + cfg.deputyGun*numAccomplices
	gunCounts = {config.guns[cfg.gunIndex].gunName: gunCount}
	self.cash = rng.randi_range(cfg.minCash, cfg.maxCash+1)


func _attackRating():
	return ._attackRating() - cfg.attackPenalty

func _defendRating():
	return ._defendRating() - cfg.defendPenalty

func _armour():
	if numAccomplices == 0:
		return cfg.armour
	return cfg.deputyArmour


func _getName():
	return cfg.copName

func getNumDeputies():
	return numAccomplices

func howArmed():

	var maxDamage = 0
	for gun in config.guns:
		maxDamage = max(maxDamage, gun.damage)
	maxDamage *= (getNumDeputies()+2)

	var damage = config.guns[cfg.gunIndex].damage * numGuns()

	var armPercent = 100 * damage / maxDamage

	if armPercent < 10: return "pitifully armed"
	elif armPercent < 25: return "lightly armed"
	elif armPercent < 60: return "moderately well armed"
	elif armPercent < 80: return "heavily armed"
	return "armed to the teeth"
	
