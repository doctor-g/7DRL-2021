extends Node

func _init():
	name = "Weapon"


func can_play(game:Game) -> bool:
	return game.has_monster() and game.count_items() < game.room.max_items


func execute(game:Game) -> void:
	var weapon = preload("res://src/Items/Item.tscn").instance()
	weapon.frame = 323
	weapon.type = load("res://src/Items/WeaponType.gd").new()
	weapon.type.weapon = load("res://src/Weapons/Dagger.gd").new()
	game.add_item(weapon)
