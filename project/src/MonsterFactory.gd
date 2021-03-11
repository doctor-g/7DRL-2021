extends Node

var _monsters = {
	1: [
		# Name, HP, damage, ac, frame
		[ "Goblin", 4, "1d4", 11, 121 ],
		[ "Snake", 4, "1d3+1", 11, 412 ],
		[ "Bat", 3, "1d2", 12, 410 ]
	],
	2: [
		[ "Orc", 8, "1d6", 12, 457 ],
		[ "Skeleton", 10, "1d4+1", 10, 317],
		[ "Bandit", 8, "1d6+1", 11, 76 ]
	]
}

func create_monster(level:int)->MonsterPawn:
	var monster_data = _get_random_monster_data(level)
	var monster = load("res://src/Dungeon/MonsterPawn.tscn").instance()
	monster.name = monster_data[0]
	monster.level = 1
	monster.max_hp = monster_data[1]
	monster.damage = monster_data[2]
	monster.ac = monster_data[3]
	monster.frame = monster_data[4]
	return monster


func _get_random_monster_data(level):
	var options : Array = _monsters[level]
	return options[randi() % options.size()]
