class_name ArmorActor
extends "res://src/Dungeon/ItemActor.gd"

var ac_bonus : int

func to_string()->String:
	return "%s (+%d)" % [name, ac_bonus]
