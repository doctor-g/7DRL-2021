extends Node

var _monsters = {
	1: [
		# Name, HP, damage, ac, frame
		[ "Rat", 2, "1d3", 10, 415 ],
		[ "Snake", 2, "1d3+1", 11, 412 ],
		[ "Bat", 1, "1d2", 12, 410 ]
	],
	2: [
		[ "Orc", 8, "1d6", 12, 457 ],
		[ "Skeleton", 10, "1d4+1", 10, 317],
		[ "Bandit", 8, "1d6+1", 11, 76 ]
	]
}

var level := 1

func _init():
	name = "Monster"


func can_play(game:Game) -> bool:
	return game.count_monsters() < game.room.max_monsters \
		and game.room.monsters_played < game.room.max_monsters
	

func execute(game:Game) -> void:
	var monster_data = _get_random_monster(1)
	var monster = preload("res://src/Monsters/Monster.tscn").instance()
	monster.name = monster_data[0]
	monster.level = 1
	monster.max_hp = monster_data[1]
	monster.damage = monster_data[2]
	monster.ac = monster_data[3]
	monster.frame = monster_data[4]
	game.add_monster(monster)


func _get_random_monster(lev:int)->Array:
	var options : Array = _monsters[lev]
	return options[randi()%options.size()]
