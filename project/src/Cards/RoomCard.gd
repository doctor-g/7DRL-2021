extends "res://src/Card.gd"

var _maps = {
	1: [
		{
			"name": "Small Chamber",
			"tiles": [
				"########",
				"#   I  #",
				"#S    MD",
				"#   I  #",
				"########",
			]
		},
		{
			"name": "Guard Room",
			"tiles": [
				"########",
				"#     ID",
				"#S M M #",
				"#     I#",
				"########"
			]
		},
		{
			"name": "Collapsed Room",
			"tiles": [
				" #######",
				"##     #",
				"#S  M ID",
				"#     ##",
				"####### "
			]
		}
	],
	2: [
		{
			"name": "Great Room",
			"tiles": [
				"##########",
				"#       I#",
				"#       MD",
				"#S   M  M#",
				"#       I#",
				"##########"
			]
		},
		{
			"name": "Den",
			"tiles":[
				"##########",
				"#M      M#",
				"#S      ID",
				"#     I  #",
				"#M     IM#",
				"##########"
			]
		}
	],
	3: [
		{
			"name": "Treasure Room",
			"tiles": [
				"##########",
				"#        D",
				"#        #",
				"#S      M#",
				"#     MMI#",
				"#    MIII#",
				"##########"
			]
		}
	]
}


func _init():
	title = "Room"


func can_play(game:Game) -> bool:
	var current_level = game.get_dungeon_level()
	return level > current_level


func play(game:Game) -> void:
	var options = _maps[level]
	var conf = options[randi() % options.size()]
	conf["level"] = level
	game.get_node("Dungeon").replace(conf)

	
