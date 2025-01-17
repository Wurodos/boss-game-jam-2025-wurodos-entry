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
var luck : int

var selected : bool

var poison : int
var stunned : bool

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
	luck = 0
	poison = 0
	stunned = false
	hp = max_hp
	alive = true
	

func visualise() -> void:
	$Hat.texture = hat.sprite
	$Weapon.texture = weapon.sprite
	$Trinket.texture = trinket.sprite
	$Health.max_value = max_hp
	$Health.value = hp
	$Damage/AnimationPlayer.animation_finished.connect(hide_dmg)
	if luck > 0:
		$LuckText.visible = true
		$LuckText.text = str(luck)

func equip(item : Item) -> void:
	match item.type:
		ITEM_TYPE.WEAPON: weapon = item
		ITEM_TYPE.HAT: hat = item
		ITEM_TYPE.TRINKET: trinket = item
	if item.effects.has("MAXHP"):
		max_hp += item.effects["MAXHP"]
		hp = max_hp
	if item.effects.has("LUCK"):
		luck += item.effects["LUCK"]

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

func hide_dmg(anim_name : StringName) -> void:
	if anim_name == "drop":
		$Damage.visible = false
		$Damage/AnimationPlayer.play("RESET")	

func change_hp(delta : int) -> void:
	
	if delta < 0:
		$Damage.label_settings.font_color = Color.RED
		$Damage.text = str(-delta)
		$Damage.visible = true
		$Damage/AnimationPlayer.play("drop")
	else:
		$Damage.label_settings.font_color = Color.GREEN
		$Damage.text = str(delta)
		$Damage.visible = true
		$Damage/AnimationPlayer.play("drop")
	
	hp += delta
	if hp > max_hp: hp = max_hp
	$Health.value = hp
	if hp <= 0 and alive:
		die()

func apply_poison(psn : int) -> void:
	poison += psn
	if poison > 0:
		$PoisonText.text = str(poison)
		$PoisonText.visible = true
	else: $PoisonText.visible = false

func apply_stun() -> void:
	stunned = true
	$Stun.visible = true

func draft_mode() -> Button:
	$Draft.visible = true
	return $Draft

func die() -> void:
	alive = false
	dead.emit(position_id)
	visible = false
