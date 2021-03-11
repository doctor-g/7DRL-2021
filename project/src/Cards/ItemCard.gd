extends "res://src/Card.gd"


func _init():
	has_threat_requirement = true


func can_play(game:Game) -> bool:
	var total_level = game.get_total_monster_levels()
	return total_level >= level and game.can_add_item()
