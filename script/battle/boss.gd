extends Resource

class_name Boss

@export var name : String
@export var health : int
@export var sprite : Texture2D

var pending_move : Callable

func attack(fighter: Fighter, dmg : int):
	dmg -= fighter.defence
	if dmg > 0:
		fighter.change_hp(-dmg)
