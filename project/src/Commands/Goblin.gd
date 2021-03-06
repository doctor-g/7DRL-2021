extends Node

func _init():
	name = "Goblin"


func execute() -> void:
	var goblin = preload("res://src/Monsters/Goblin.tscn").instance()
	GameState.room.add_monster(goblin)
