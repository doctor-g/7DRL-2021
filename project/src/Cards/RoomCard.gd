extends "res://src/Card.gd"


func _init():
	title = "Room"


func can_play(game:Game) -> bool:
	var current_level = game.get_dungeon_level()
	return level > current_level


func play(game:Game) -> void:
	var sample = {
		"name": "The Great Room",
		"level": 1,
		"tiles": [
			"########",
			"#   I  #",
			"#S    MD",
			"#   I  #",
			"########",
		]
	}
	game.get_node("Dungeon").replace(sample)

	
