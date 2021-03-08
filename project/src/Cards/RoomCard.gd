extends "res://src/Card.gd"

var _rooms = {
	1: load("res://src/Rooms/SmallChamber.gd"),
	2: load("res://src/Rooms/MediumChamber.gd")
}

func _init():
	title = "Room"


func can_play(game:Game) -> bool:
	return game.room.level < level \
		and game.room.items_played <= game.room.max_items \
		and game.room.monsters_played <= game.room.max_monsters


func play(game:Game) -> void:
	var new_room = _rooms[level].new()
	new_room.level = level
	new_room.items_played = game.room.items_played
	new_room.monsters_played = game.room.monsters_played
	Log.log("You expand the %s into a %s." % [game.room.name, new_room.name])
	game.room = new_room
	
