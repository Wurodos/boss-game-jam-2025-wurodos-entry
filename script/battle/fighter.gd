extends Node2D

class_name Fighter 

const ITEM_TYPE = preload("res://script/battle/item.gd").Type
const POSITION_ID = preload("res://script/battle/spinner_mng.gd").Position

var hat : Item
var weapon : Item
var trinket : Item
var max_hp : int
var hp : int
var defence : int

var selected : bool

var alive : bool

var position_id : POSITION_ID

signal dead(pos_id : POSITION_ID)

func _init() -> void:
	hat = Item.new()
	weapon = Item.new()
	trinket = Item.new()
	selected = false
	max_hp = 20
	defence = 0
	hp = max_hp
	alive = true

func visualise() -> void:
	$Hat.texture = hat.sprite
	$Weapon.texture = weapon.sprite
	$Trinket.texture = trinket.sprite
	$Health.max_value = max_hp
	$Health.value = hp

func equip(item : Item) -> void:
	match item.type:
		ITEM_TYPE.WEAPON: weapon = item
		ITEM_TYPE.HAT: hat = item
		ITEM_TYPE.TRINKET: trinket = item
	if item.effects.has("MAXHP"):
		max_hp += item.effects["MAXHP"]
		hp = max_hp

func get_all_items() -> Array[Item]:
	var item_array : Array[Item]
	if hat.type != ITEM_TYPE.NO_ITEM: item_array.append(hat)
	if weapon.type != ITEM_TYPE.NO_ITEM: item_array.append(weapon)
	if trinket.type != ITEM_TYPE.NO_ITEM: item_array.append(trinket)
	return item_array

func get_all_items_with_actions() -> Array[Item]:
	var item_array : Array[Item]
	if hat.has_action(): item_array.append(hat)
	if weapon.has_action(): item_array.append(weapon)
	if trinket.has_action(): item_array.append(trinket)
	
	return item_array

var target_visible = false

func toggle_target(state : bool) -> void:
	$Target.visible = state
	target_visible = state

func change_hp(delta : int) -> void:
	hp += delta
	if hp > max_hp: hp = max_hp
	$Health.value = hp
	if hp <= 0:
		die()

func die() -> void:
	alive = false
	dead.emit(position_id)
	visible = false
