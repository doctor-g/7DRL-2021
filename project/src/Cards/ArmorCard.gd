extends "res://src/Card.gd"

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
	]
}

func _init():
	title = "Armor"


func can_play(game:Game) -> bool:
	return game.get_total_monster_levels() >= 1 \
		and game.room.items_played < game.room.max_items


func play(game:Game) -> void:
	var armor_data = _get_random(_armors)
	var armor = preload("res://src/Items/Item.tscn").instance()
	armor.set_script(load("res://src/Items/Armor.gd"))
	armor.name = armor_data[0]
	armor.ac_bonus = armor_data[1]
	armor.frame = armor_data[2]
	game.add_item(armor)
