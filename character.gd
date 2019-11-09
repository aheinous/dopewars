var cash := 0
var health := 100
var gunCounts := {}
var numAccomplices := 0
var rng


enum AttackRes {MISS, NONFATAL_HIT, ACCOMPLICE_KILLED, DEAD}


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
	if numAccomplices == 0:
		return 100
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
		return AttackRes.MISS


func _calcDamage(other):
	var damage = 0
	for gunName in gunCounts:
		var count = gunCounts[gunName]
		for i in range(count):
			damage += rng.randi_range(0, config.gunsByName[gunName].damage-1)
	damage = (damage * 100 / other._armour()) as int
	damage = max(1, damage)
	return damage
	
func takeDamage(amnt):
	print("%s taking %s damage" % [_getName(), amnt])
	if health - amnt <= 0:
		if numAccomplices > 0:
			numAccomplices -= 1
			health = 100
			_onAccompliceKilled()
			return AttackRes.ACCOMPLICE_KILLED
		else:
			health = 0
			return AttackRes.DEAD
	else:
		health -= amnt
		return AttackRes.NONFATAL_HIT



func _onAccompliceKilled():
	pass
