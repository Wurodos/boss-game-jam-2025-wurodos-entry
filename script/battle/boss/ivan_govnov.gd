extends Boss

enum Attack {LOW_KICK, INTOXICATE, CRUSH, CLOSET}
var type = Attack.LOW_KICK
var last_type = Attack.LOW_KICK
var target_id = 0

# While tutorial boss can be beaten by mashing attack (multipliers are cool),
# Ivan Govnov tries to punish that 'strategy'.
# Every turn there's 40% chance that it goes into 
# "Defence Stance", where it receives less damage and
# deals half the damage that it receives.
# It also [RANDOM] + [RANDOM] - 1 POISON 
# Otherwise, it cycles through 3 attacks:
# [Right] + [Left] - 8 DMG
# [Top-Most] - 3 POISON
# [Random] - 8 DMG, stun (can't use spinner next turn)



func decide_targets(team : Array[Fighter]):
	thorns = false
	match(type):
		Attack.LOW_KICK:
			if team[0].alive:
				team[0].toggle_target(true)
			if team[1].alive:
				team[1].toggle_target(true)
			pending_move = low_kick
		Attack.INTOXICATE:
			target_id = 0
			for fighter in team:
				if fighter.alive:
					fighter.toggle_target(true)
					break
				target_id += 1
			pending_move = intoxicate
		Attack.CRUSH:
			var r = randi_range(0, count_alive(team)-1)
			target_id = 0
			for fighter in team:
				if fighter.alive:
					if r == 0: 
						fighter.toggle_target(true)
						break
					else: r -= 1
				target_id += 1
			pending_move = crush
		Attack.CLOSET:
			if count_alive(team) > 2: target_id = randi_range(0, 2)
			else: target_id = -1
			var t = 2
			var i = 0
			for fighter in team:
				if fighter.alive and i != target_id:
					fighter.toggle_target(true)
					t -= 1
					if t == 0: break
				i += 1
			pending_move = closet


func low_kick(team : Array[Fighter]):
	print("LOW KICK")
	attack(team[0], 8)
	attack(team[1], 8)
	var r = randi_range(0, 9)
	if r < 4:
		last_type = Attack.INTOXICATE
		type = Attack.CLOSET
	else: type = Attack.INTOXICATE

func intoxicate(team : Array[Fighter]):
	print("INTOXICATE")
	poison(team[target_id], 3)
	var r = randi_range(0, 9)
	if r < 4:
		last_type = Attack.CRUSH
		type = Attack.CLOSET
	else: type = Attack.CRUSH

func crush(team : Array[Fighter]):
	print("CRUSH")
	attack(team[target_id], 8)
	stun(team[target_id])
	var r = randi_range(0, 9)
	if r < 4:
		last_type = Attack.LOW_KICK
		type = Attack.CLOSET
	else: type = Attack.LOW_KICK

func closet(team : Array[Fighter]):
	print("CLOSET")
	thorns = true
	
	for i in range(3):
		if i != target_id: poison(team[i], 1)
	type = last_type
	last_type = Attack.CLOSET
