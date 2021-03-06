extends Node

func _init():
	name = "Gold"


func can_play(game:Game) -> bool:
	return game.has_monster() and game.count_items() < game.room.max_items


func execute(game:Game) -> void:
	var item = preload("res://src/Items/Item.tscn").instance()
	item.frame = 803
	item.type = load("res://src/Items/GoldType.gd").new()
	item.type.amount = 100
	game.add_item(item)
