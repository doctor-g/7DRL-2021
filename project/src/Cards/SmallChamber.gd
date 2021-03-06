extends Node

func _init():
	name = "Small Chamber"


func can_play(game:Game) -> bool:
	return game.room.name == "Tunnel"


func execute(game:Game) -> void:
	game.room = load("res://src/Rooms/SmallChamber.gd").new()
