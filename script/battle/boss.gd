extends Resource

class_name Boss

@export var name : String
@export var health : int
@export var sprite : Texture2D

var pending_move : Callable
var thorns = false

func count_alive(fighters : Array[Fighter]) -> int:
	var k = 0
	for f in fighters: if f.alive: k += 1
	return k

func attack(fighter: Fighter, dmg : int):
	dmg -= fighter.defence
	if dmg > 0:
		fighter.change_hp(-dmg)

func poison(fighter: Fighter, psn : int):
	if psn > 0:
		fighter.apply_poison(psn)

func stun(fighter: Fighter):
	fighter.apply_stun()
