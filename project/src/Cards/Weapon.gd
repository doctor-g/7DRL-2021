extends Node

func _init():
	name = "Weapon"


func can_play(game:Game) -> bool:
	return game.has_monster() and not game.has_loot()


func execute(game:Game) -> void:
	var weapon = preload("res://src/Items/Weapon.tscn").instance()
	game.add_item(weapon)
