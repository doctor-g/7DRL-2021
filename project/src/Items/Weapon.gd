extends "res://src/Items/Item.gd"

var damage: String


func pickup(player)->void:
	player.weapon = self


func get_name() -> String:
	return "%s (%s)" % [name, damage]


func compute_damage():
	return Dice.roll(damage)

