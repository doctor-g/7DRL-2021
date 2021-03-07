extends Node

const _BASE_AC := 10

signal hp_changed
signal weapon_changed
signal armor_changed
signal gold_changed
signal ac_changed

var max_hp := 10
var hp := max_hp setget _set_hp
var weapon = load("res://src/Weapons/BareHands.gd").new() setget _set_weapon
var armor = load("res://src/Armor/PeasantClothes.gd").new()  setget _set_armor
var gold := 0 setget _set_gold
var ac := 10 setget _set_ac


func _set_hp(value):
	hp = value
	emit_signal("hp_changed")


func _set_weapon(value):
	weapon = value
	emit_signal("weapon_changed")
	
	
func _set_armor(value):
	armor = value
	emit_signal("armor_changed")
	_set_ac(_BASE_AC + armor.ac_bonus)


func _set_gold(value):
	gold = value
	emit_signal("gold_changed")


func _set_ac(value):
	ac = value
	emit_signal("ac_changed")
