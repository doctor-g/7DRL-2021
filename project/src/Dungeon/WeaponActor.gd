class_name WeaponActor
extends "res://src/Dungeon/ItemActor.gd"

var damage : String

func to_string()->String:
	return "%s (%s)" % [name, damage]
