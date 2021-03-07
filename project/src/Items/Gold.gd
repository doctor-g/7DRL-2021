extends "res://src/Items/Item.gd"

var amount : int


func pickup(player)->void:
	player.gold += amount
