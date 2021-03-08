extends "res://src/Card.gd"

var _rooms = {
	1: load("res://src/Rooms/SmallChamber.gd"),
	2: load("res://src/Rooms/MediumChamber.gd")
}

func _init():
	title = "Room"


func can_play(game:Game) -> bool:
	return game.room.name == "Tunnel" \
		and game.room.monsters_played == 0 \
		and game.room.items_played == 0


func play(game:Game) -> void:
	game.room = _rooms[level].new()
	Log.log("You expand the tunnel into a %s." % game.room.name)
