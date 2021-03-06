extends Node

signal hp_changed
signal weapon_changed

var max_hp := 10
var hp := max_hp setget _set_hp
var weapon = load("res://src/Weapons/BareHands.gd").new() setget _set_weapon


func _set_hp(value):
	hp = value
	emit_signal("hp_changed")


func _set_weapon(value):
	weapon = value
	emit_signal("weapon_changed")
