extends Node

var min_damage : int
var max_damage : int

func _init(mindmg, maxdmg).():
	assert(mindmg <= maxdmg)
	assert(mindmg>0)
	min_damage = mindmg
	max_damage = maxdmg


func get_name() -> String:
	return "%s (%d-%d)" % [name, min_damage, max_damage]


func compute_damage():
	return 1 if max_damage == min_damage else randi() % (max_damage - min_damage) + min_damage
