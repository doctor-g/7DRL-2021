extends Node

func _init():
	name = "Armor"


func can_play(game:Game) -> bool:
	return game.has_monster() and game.count_items() < game.room.max_items


func execute(game:Game) -> void:
	var armor = preload("res://src/Items/Item.tscn").instance()
	armor.frame = 81
	armor.type = load("res://src/Items/ArmorType.gd").new()
	armor.type.armor = load("res://src/Armor/LeatherArmor.gd").new()
	game.add_item(armor)
