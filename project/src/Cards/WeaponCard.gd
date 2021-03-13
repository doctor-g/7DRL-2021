extends "res://src/Cards/ItemCard.gd"

var _weapons = {
	1: [
		["Dagger", "1d4", 324],
		["Club", "1d6", 128],
		["Bone Club", "1d4", 608],
		["Staff", "1d6", 224],
		["Pickaxe", "1d4+1", 283]
	],
	2: [
		[ "Broadsword", "1d8", 420 ],
		[ "Longsword", "1d8", 368 ],
		[ "Mace", "2d4", 421 ],
		[ "Spiked Club", "1d6+1", 129 ],
		[ "Axe", "1d8", 376]
	],
	3: [
		[ "Magic Longsword", "1d8+1", 320],
		[ "Greataxe", "1d10", 375],
		[ "Greatsword", "2d6", 465]
	]
}


func _init():
	title = "Weapon"


func play(game:Game) -> void:
	var weapon_data = _get_random(_weapons)
	var weapon : Actor = load("res://src/Dungeon/ItemActor.tscn").instance()
	weapon.set_script(load("res://src/Dungeon/WeaponActor.gd"))
	weapon.name = weapon_data[0]
	weapon.damage = weapon_data[1]
	weapon.frame = weapon_data[2]
	game.add_item(weapon)
	Log.log("You summon a %s." % weapon.name)

