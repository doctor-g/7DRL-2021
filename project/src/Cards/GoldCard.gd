extends "res://src/Card.gd"

var _range = {
	1: "2d10",
	2: "5d6"
}

func _init():
	title = "Gold"


func can_play(game:Game) -> bool:
	return game.get_total_monster_levels() >= 1 \
		and game.room.items_played < game.room.max_items


func play(game:Game) -> void:
	var item = preload("res://src/Items/Item.tscn").instance()
	item.set_script(load("res://src/Items/Gold.gd"))
	item.amount = Dice.roll(_range[level])
	item.frame = 803
	game.add_item(item)
