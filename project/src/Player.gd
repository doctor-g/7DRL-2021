extends Node

signal hp_changed

var max_hp := 10
var hp := max_hp setget _set_hp


func _set_hp(value):
	hp = value
	emit_signal("hp_changed")
