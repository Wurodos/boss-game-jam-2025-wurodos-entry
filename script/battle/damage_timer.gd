extends Label

@export var strings : Array[String]
var damage_multiplier : int = 1
var iterator : int = 0

func start_timer():
	damage_multiplier = strings.size() - 1
	text = strings[0]
	iterator = 1
	$Timer.start()

func decrease():
	damage_multiplier -= 1
	text = strings[iterator]
	iterator += 1
	if iterator < strings.size():
		$Timer.start()
	
