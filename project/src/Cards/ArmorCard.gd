extends "res://src/Cards/ItemCard.gd"

var _armors = {
	1: [
		[ "Padded Armor", +2, 80 ], 
		[ "Leather Armor", +2, 80 ], 
		[ "Heavy Clothes", +1, 85 ]
	],
	2: [
		[ "Ring Mail", +4, 82 ],
		[ "Studded Leather", +3, 80 ],
		[ "Chain Mail", +4, 82 ]
	],
	3: [
		[ "Banded Mail", +5, 84],
		[ "Plate Mail", +6, 83],
		[ "Full Plate Mail", +7, 83]
	]
}

func _init():
	title = "Armor"


func play(game:Game) -> void:
	var armor_data = _get_random(_armors)
	var armor = load("res://src/Dungeon/ItemActor.tscn").instance()
	armor.set_script(load("res://src/Dungeon/ArmorActor.gd"))
	armor.name = armor_data[0]
	armor.ac_bonus = armor_data[1]
	armor.frame = armor_data[2]
	game.add_item(armor)
	Log.log("You summon %s." % armor.name)
