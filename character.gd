var cash := 0
var health := 100
var gunQuantities := {}
var bitches := 0

func numGuns():
    var n = 0
    for name in gunQuantities:
        n += gunQuantities[name]
    return n
