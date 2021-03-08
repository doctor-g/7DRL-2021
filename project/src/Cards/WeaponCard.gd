extends "res://src/Card.gd"

var _weapons = {
	1: [
		["Dagger", "1d4", 324],
		["Club", "1d6", 128],
		["Bone", "1d6", 608]
	],
	2: [
		[ "Longsword", "1d8", 368 ],
		[ "Mace", "2d4", 421 ],
		[ "Spiked Club", "1d6+1", 129 ]
	]
}


func _init():
	title = "Weapon"


func can_play(game:Game) -> bool:
	return game.get_total_monster_levels() >= 1 \
		and game.room.items_played < game.room.max_items


func play(game:Game) -> void:
	var weapon_data = _get_random(_weapons)
	var weapon = preload("res://src/Items/Item.tscn").instance()
	weapon.set_script(load("res://src/Items/Weapon.gd"))
	weapon.name = weapon_data[0]	
	weapon.damage = weapon_data[1]
	weapon.frame = weapon_data[2]	
	game.add_item(weapon)
	Log.log("You summon a %s." % weapon.name)

