extends Node

func _init():
	name = "Goblin"


func execute() -> void:
	var goblin = preload("res://src/Monsters/Goblin.tscn").instance()
	goblin.position = Vector2(300, 50)
	GameState.room.add_child(goblin)
