extends Node

var ac_bonus := 0

func _init(_ac_bonus).():
	ac_bonus = _ac_bonus


func get_name() -> String:
	return "%s (+%d)" % [name, ac_bonus]
