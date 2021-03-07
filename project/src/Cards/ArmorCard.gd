extends Node

var _armors = {
	0: [
		[ "Padded Armor", +2, 80 ], 
		[ "Leather Armor", +2, 80 ], 
		[ "Heavy Clothes", +1, 85 ]
	]
}

func _init():
	name = "Armor"


func can_play(game:Game) -> bool:
	return game.has_monster() and game.count_items() < game.room.max_items


func execute(game:Game) -> void:
	var armor_data = _select_armor(0)
	var armor = preload("res://src/Items/Item.tscn").instance()
	armor.set_script(load("res://src/Items/Armor.gd"))
	armor.name = armor_data[0]
	armor.ac_bonus = armor_data[1]
	armor.frame = armor_data[2]
	game.add_item(armor)


func _select_armor(level:int)->Array:
	var options : Array = _armors[level]
	return options[randi()%options.size()]
