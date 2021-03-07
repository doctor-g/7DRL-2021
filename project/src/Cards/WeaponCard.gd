extends Node

var _weapons = {
	0: [
		["Dagger", "1d4", 324],
		["Club", "1d6", 128],
		["Bone", "1d6", 608]
	]
}


func _init():
	name = "Weapon"


func can_play(game:Game) -> bool:
	return game.has_monster() and game.count_items() < game.room.max_items


func execute(game:Game) -> void:
	var weapon_data = _get_random_weapon(0)
	var weapon = preload("res://src/Items/Item.tscn").instance()
	weapon.set_script(load("res://src/Items/Weapon.gd"))
	weapon.name = weapon_data[0]	
	weapon.damage = weapon_data[1]
	weapon.frame = weapon_data[2]	
	game.add_item(weapon)


func _get_random_weapon(level:int) -> Array:
	var options : Array = _weapons[level]
	return options[randi() % options.size()]
