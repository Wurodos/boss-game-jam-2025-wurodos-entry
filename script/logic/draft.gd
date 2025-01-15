extends Node

var n = 0

@export var weapon_pool : Array[Item]
@export var hat_pool : Array[Item]
@export var trinket_pool : Array[Item]


func _ready() -> void:
	for fighter : Fighter in $FighterParent.get_children():
		fighter.equip(weapon_pool.pick_random())
		fighter.equip(hat_pool.pick_random())
		fighter.equip(trinket_pool.pick_random())
		fighter.draft_mode().pressed.connect(func() : chosen(fighter))
		fighter.visualise()

func chosen(fighter : Fighter):
	Heaven.drafted.append(fighter)
	fighter.visible = false
	fighter.reparent(get_tree().get_root())
	n += 1
	if n == 3:
		get_tree().change_scene_to_file("res://scene/game.tscn")
