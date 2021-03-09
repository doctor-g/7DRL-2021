extends "res://src/Card.gd"


func can_play(game:Game) -> bool:
	var monsters = game.get_monsters()
	var total_level := 0
	for monster in monsters:
		total_level += monster.level
	return total_level >= level and game.can_add_item()
