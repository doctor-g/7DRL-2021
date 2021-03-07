extends Node

func _init():
	name = "Small Chamber"


func can_play(game:Game) -> bool:
	return game.room.name == "Tunnel" \
		and game.room.monsters_played == 0 \
		and game.room.items_played == 0


func execute(game:Game) -> void:
	game.room = load("res://src/Rooms/SmallChamber.gd").new()
