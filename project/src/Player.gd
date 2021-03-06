extends Node

signal hp_changed

var hp := 10 setget _set_hp


func _set_hp(value):
	hp = value
	emit_signal("hp_changed")
