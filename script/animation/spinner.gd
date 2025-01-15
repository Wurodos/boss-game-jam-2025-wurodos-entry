extends Node2D

const Action = preload("res://script/logic/global.gd").Action

@export var rotation_speed = 10
@export var segments : int

var actions : Array[Action]

var current_segment : int
var current_rotation : float
var segment_length : float
var last_positive = true

func _ready() -> void:
	current_segment = 0
	current_rotation = 0
	segment_length = 2*PI / segments
	print(current_segment)

func execute_selected() -> void:
	actions[current_segment].execute()

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_J):
		rotation -= rotation_speed * delta
		current_rotation -= rotation_speed * delta
		if current_rotation < -segment_length:
			last_positive = false
			current_rotation += segment_length
			if current_segment == 0 : current_segment = segments - 1
			else: current_segment -= 1
			print(current_segment)
		elif current_rotation < 0 and last_positive:
			last_positive = false
			if current_segment == 0 : current_segment = segments - 1
			else: current_segment -= 1
			print(current_segment)
			
	elif Input.is_key_pressed(KEY_L):
		rotation += rotation_speed * delta
		current_rotation += rotation_speed * delta
		if current_rotation > segment_length:
			last_positive = true
			current_rotation -= segment_length
			if current_segment == segments - 1 : current_segment = 0
			else: current_segment += 1
			print(current_segment)
		elif current_rotation > 0 and not last_positive:
			last_positive = true
			if current_segment == segments - 1 : current_segment = 0
			else: current_segment += 1
			print(current_segment)
