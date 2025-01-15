extends Boss

enum Attack {SPLASH, SINGLE}

var type = Attack.SPLASH

func decide_targets(team : Array[Fighter]):
	if type == Attack.SPLASH:
		for fighter in team:
			fighter.toggle_target(true)
		pending_move = test_splash
	else:
		team[0].toggle_target(true)
		pending_move = test_single

func test_splash(team : Array[Fighter]):
	print("SPLASH ATTACK")
	for fighter in team:
		attack(fighter, 5)
	type = Attack.SINGLE

func test_single(team : Array[Fighter]):
	print("SINGLE ATTACK")
	attack(team[0], 8)
	type = Attack.SPLASH
	
