extends Node

const fighter_prefab = preload("res://scene/sub/fighter.tscn")

class Action:
	var effect : Callable
	var amount : int
	
	var sprite : Texture
	
	var fighter : Fighter
	
	var has_secondary : bool
	
	var secondary_effect : Callable
	var secondary_amount : int
	
	func _init(effect : Callable, amount : int, fighter : Fighter = null, sprite : Texture = null) -> void:
		self.effect = effect
		self.amount = amount
		self.sprite = sprite
		self.has_secondary = false
		if fighter != null: self.fighter = fighter
	
	func execute():
		effect.call(amount, fighter)
		if has_secondary:
			secondary_effect.call(secondary_amount, fighter)


var player_team : Array[Fighter]
@export var boss : Boss
@export var item_pool : Array[Item]

func deal_dmg(dmg : int, _fighter = null):
	print("Dealt " + str(dmg) + " dmg to boss!")
	#TODO Animation
	if $UI/Speed.damage_multiplier > 0: dmg *= $UI/Speed.damage_multiplier
	else : dmg /= 2
	boss.health -= dmg
	$UI/Health/Bar.value = boss.health
	

func heal(amount : int, fighter : Fighter):
	print("Healed " + str(amount) + "!")
	
	#TODO Animation
	fighter.change_hp(amount)

func defend(amount : int, fighter : Fighter):
	print("Protected " + str(amount) + "!")
	
	#TODO Animation
	fighter.defence += amount


func rotate_fighters(clockwise : bool):
	if clockwise:
		var temp = player_team[2]
		player_team[2] = player_team[1]
		player_team[1] = player_team[0]
		player_team[0] = temp
		
		player_team[0].toggle_target(player_team[1].target_visible)
		player_team[1].toggle_target(player_team[2].target_visible)
		temp.toggle_target(player_team[0].target_visible)
	else:
		var temp = player_team[0]
		player_team[0] = player_team[1]
		player_team[1] = player_team[2]
		player_team[2] = temp
		
		player_team[2].toggle_target(player_team[1].target_visible)
		player_team[1].toggle_target(player_team[0].target_visible)
		temp.toggle_target(player_team[2].target_visible)
		

# BOSS

func decide_targets():
	boss.decide_targets(player_team)

func boss_turn():
	print("Boss turn...")
	
	boss.pending_move.call(player_team)
	
	for fighter in player_team:
		fighter.defence = 0
		fighter.toggle_target(false)
	
	decide_targets()
	$UI/Speed.start_timer()


# TESTING TESTING
func _ready() -> void:
	player_team.append(fighter_prefab.instantiate())
	player_team.append(fighter_prefab.instantiate())
	player_team.append(fighter_prefab.instantiate())
	
	player_team[0].equip(item_pool[0].clone())
	start_battle()

func start_battle() -> void:
	visualise_fighters()
	visualise_boss()
	decide_targets()
	$UI/Speed.start_timer()

func visualise_fighters() -> void:
	for fighter in player_team:
		$FighterCircle.add_fighter(fighter)
		fighter.visualise()

func visualise_boss() -> void:
	$Boss.texture = boss.sprite
	$UI/Bossname.text = boss.name
	$UI/Health/Bar.max_value = boss.health
	$UI/Health/Bar.value = boss.health

func darken() -> void:
	$UI/Darken.visible = true

func undarken() -> void:
	$UI/Darken.visible = false
