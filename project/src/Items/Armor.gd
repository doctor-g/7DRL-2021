extends "res://src/Items/Item.gd"

var ac_bonus: int


func pickup(player)->void:
	player.armor = self


func get_name() -> String:
	return "%s (%d)" % [name, ac_bonus]
