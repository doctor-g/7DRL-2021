extends Node

var _range = {
	0: "2d10"
}

func _init():
	name = "Gold"


func can_play(game:Game) -> bool:
	return game.get_total_monster_levels() >= 1 \
		and game.count_items() < game.room.max_items


func execute(game:Game) -> void:
	var item = preload("res://src/Items/Item.tscn").instance()
	item.set_script(load("res://src/Items/Gold.gd"))
	item.amount = Dice.roll(_range[0])
	item.frame = 803
	game.add_item(item)
