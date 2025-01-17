extends Node2D

const spinner3_prefab = preload("res://scene/sub/spinner3.tscn")
const effect_prefab = preload("res://scene/sub/effect.tscn")

const Action = preload("res://script/logic/global.gd").Action

# effect icons
const dmg_icon = preload("res://sprite/icon/DMG.svg")
const heal_icon = preload("res://sprite/icon/HEAL.svg")
const def_icon = preload("res://sprite/icon/DEF.svg")

signal darken
signal undarken
signal end_turn

@export var top_pos : Vector2
@export var right_pos : Vector2
@export var left_pos : Vector2

var top_fighter : Fighter
var right_fighter : Fighter
var left_fighter : Fighter

var any_spinners = false

enum Position{TOP, RIGHT, LEFT}

func add_fighter(fighter : Fighter) -> void:
	fighter.dead.connect(fighter_killed)
	fighter.reparent(self)
	if top_fighter == null:
		top_fighter = fighter
		top_fighter.position_id = Position.TOP
		fighter.position = top_pos
	elif right_fighter == null:
		right_fighter = fighter
		right_fighter.position_id = Position.RIGHT
		fighter.position = right_pos
	elif left_fighter == null:
		left_fighter = fighter
		left_fighter.position_id = Position.LEFT
		fighter.position = left_pos
	dude_num += 1
	

var dude_num = 0
signal dudes_are_dead

func fighter_killed(position_id : Position) -> void:
	dude_num -= 1
	if dude_num == 0:
		dudes_are_dead.emit()

func fighter_chosen(fighter : Fighter) -> void:
	if fighter.selected: return
	if $SpinnerParent.get_child_count() == 0: darken.emit() 
	
	var actions : Array[Action]
	
	var items = fighter.get_all_items_with_actions()
	var segment_n = items.size()
	
	fighter.selected = true
	any_spinners = true
	
	for item in items:
		if item.effects.has("DMG"):
			actions.append(Action.new(get_parent().deal_dmg,\
			item.effects["DMG"], fighter, dmg_icon))
		
	if segment_n < 1: 
		actions.append(Action.new(get_parent().deal_dmg, 2, fighter, dmg_icon))
		segment_n += 1
	if segment_n < 2:
		actions.append(Action.new(get_parent().heal, 2, fighter, heal_icon))
		segment_n += 1
	if segment_n < 3:
		actions.append(Action.new(get_parent().defend, 4, fighter, def_icon))
		segment_n += 1
	
	var spinner = spinner3_prefab.instantiate()
	$SpinnerParent.add_child(spinner)
	spinner.position = fighter.position
	
	var i = 0
	for action in actions:
		var action_node = effect_prefab.instantiate()
		action_node.get_node("Icon").texture = action.sprite
		action_node.get_node("Number").text = str(action.amount)
		spinner.get_node("Wheel").get_child(i).add_child(action_node)
		action_node.position = Vector2.ZERO
		i += 1

	spinner.get_node("Wheel").actions = actions
	
	print(segment_n)

func clear_spinners():
	top_fighter.selected = false
	right_fighter.selected = false
	left_fighter.selected = false
	any_spinners = false
	for spinner in $SpinnerParent.get_children():
		spinner.queue_free()

func execute_everything():
	for spinner in $SpinnerParent.get_children():
		spinner.get_node("Wheel").execute_selected()

# Fighter rotation

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spin_clock"):
		if not any_spinners: spin_clockwise()
	elif event.is_action_pressed("spin_counter"):
		if not any_spinners: spin_anticlockwise()
	elif event.is_action_pressed("choose_top"):
		if top_fighter.alive and not top_fighter.stunned:
			fighter_chosen(top_fighter)
	elif event.is_action_pressed("choose_right"):
		if right_fighter.alive and not right_fighter.stunned:
			fighter_chosen(right_fighter)
	elif event.is_action_pressed("choose_left"):
		if left_fighter.alive and not left_fighter.stunned:
			fighter_chosen(left_fighter)
	elif event.is_action_pressed("confirm"):
		if any_spinners:
			execute_everything()
			undarken.emit()
			clear_spinners()
			end_turn.emit()
	elif event.is_action_pressed("cancel"):
		if any_spinners:
			undarken.emit()
			clear_spinners()

signal spin(clockwise : bool)

func spin_clockwise() -> void:
	var top_temp = top_fighter
	var temp_pos = top_fighter.position
	
	top_fighter.position = right_fighter.position
	right_fighter.position = left_fighter.position
	left_fighter.position = temp_pos
	
	top_fighter = left_fighter
	left_fighter = right_fighter
	right_fighter = top_temp
	
	spin.emit(true)

func spin_anticlockwise() -> void:
	var top_temp = top_fighter
	var temp_pos = top_fighter.position
	
	top_fighter.position = left_fighter.position
	left_fighter.position = right_fighter.position
	right_fighter.position = temp_pos
	
	top_fighter = right_fighter
	right_fighter = left_fighter
	left_fighter = top_temp
	
	spin.emit(false)
