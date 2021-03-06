extends Node

func _init():
	name = "Goblin"


func can_play(game:Game) -> bool:
	return game.count_monsters() < game.room.max_monsters
	

func execute(game:Game) -> void:
	var goblin = preload("res://src/Monsters/Goblin.tscn").instance()
	game.add_monster(goblin)