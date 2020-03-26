var cash := 0
var health := 100
var gunCounts := {}
var numAccomplices := 0
var rng


enum MoveRes {NONE, MISS, NONFATAL_HIT, ACCOMPLICE_KILLED, MULTI_ACCOMPLICE_KILLED, DEAD, ESCAPE, FAILED_ESCAPE, STAND}


class Damage:
	var normal: int = 0
	var splash : int = 0


func _getName():
	return "character"

func numGuns():
	var n = 0
	for gunName in gunCounts:
		n += gunCounts[gunName]
	return n


func _attackRating():
	var rating = 80
	for gunName in gunCounts:
		rating += config.gunsByName[gunName].damage * gunCounts[gunName]
	return rating    


func _defendRating():
	return 100 - 5 * numAccomplices


func _armour():
	# if numAccomplices == 0:
	# 	return 100
	# return 50
	return 50


func attack(other):
	var attackRating = _attackRating()
	var defendRating = other._defendRating()

	print("%s attacking %s. AttackRating: %s, DefendRating: %s" % [_getName(), other._getName(), attackRating, defendRating])
	if rng.randi_range(0, attackRating-1) > rng.randi_range(0, defendRating-1):
		# hit
		print('hit')
		return other.takeDamage(_calcDamage(other))
	else:
		# miss
		print('miss')
		return MoveRes.MISS


func _calcDamage(other):
	var damage = Damage.new()
	for gunName in gunCounts:
		var count = gunCounts[gunName]
		for i in range(count):
			if config.gunsByName[gunName].splash:
				damage.splash += rng.randi_range(0, config.gunsByName[gunName].damage-1)
			else:
				damage.normal += rng.randi_range(0, config.gunsByName[gunName].damage-1)
	damage.normal = (damage.normal * 100 / other._armour()) as int
	damage.normal = max(1, damage.normal)

	damage.splash = (damage.splash * 100 / other._armour()) as int
	damage.splash = max(0, damage.splash)
	
	return damage
	
func takeDamage(damage):
	print("%s taking %s damage" % [_getName(), damage])
	var accomplicesKilled = 0
	if health - damage.normal <= 0:
		if numAccomplices > 0:
			numAccomplices -= 1
			health = 100
			_onAccompliceKilled()
			# return MoveRes.ACCOMPLICE_KILLED
			accomplicesKilled += 1
		else:
			health = 0
			return MoveRes.DEAD
	else:
		health -= damage.normal
		# return MoveRes.NONFATAL_HIT

	while damage.splash > 0:
		if health > damage.splash:
			health -= damage.splash
			damage.splash = 0
		else:
			damage.splash -= health
			if numAccomplices == 0:
				health = 0
				return MoveRes.DEAD
			numAccomplices -= 1
			accomplicesKilled += 1
			_onAccompliceKilled()
			health = 100

	match accomplicesKilled:
		0:
			return MoveRes.NONFATAL_HIT
		1:
			return MoveRes.ACCOMPLICE_KILLED
		_:
			return MoveRes.MULTI_ACCOMPLICE_KILLED



func _onAccompliceKilled():
	pass
