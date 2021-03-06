extends Node

func _init():
	name = "Weapon"


func execute(game:Game) -> void:
	var weapon = preload("res://src/Items/Weapon.tscn").instance()
	game.add_item(weapon)
