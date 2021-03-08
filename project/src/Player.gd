extends Node

const _BASE_AC := 10

signal hp_changed
signal weapon_changed
signal armor_changed
signal gold_changed
signal ac_changed
signal attribute_changed
signal xp_changed

var xp := 0 setget _set_xp

var strength := 0 setget _set_strength
var dexterity := 0 setget _set_dexterity
var constitution := 0 setget _set_constitution
var intelligence := 0 setget _set_intelligence

var max_hp := 10 + constitution
var hp := max_hp setget _set_hp
var weapon = _make_starting_weapon() setget _set_weapon
var armor = _make_starting_armor() setget _set_armor
var gold := 0 setget _set_gold
var ac := 10 + dexterity setget _set_ac

# Randomly assign the given points to the attributes
func randomize_attributes(points:int)->void:
	var attributes = ["strength", "dexterity", "constitution", "intelligence"]
	while points > 0:
		var attribute : String = attributes[randi() % attributes.size()]
		set(attribute, get(attribute)+1)
		points -= 1


func _make_starting_armor():
	var rags = preload("res://src/Items/Item.tscn").instance()
	rags.set_script(load("res://src/Items/Armor.gd"))
	rags.ac_bonus = 0
	rags.frame = 85
	rags.name = "Peasant Rags"
	return rags


func _make_starting_weapon():
	var fists = preload("res://src/Items/Item.tscn").instance()
	fists.set_script(load("res://src/Items/Weapon.gd"))
	fists.name = "Bare Hands"
	fists.damage = "1d2"
	fists.frame = 89
	return fists


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
	ac = value + dexterity
	emit_signal("ac_changed")


func _set_strength(value):
	strength = value
	emit_signal("attribute_changed")

	
func _set_dexterity(value):
	dexterity = value
	emit_signal("attribute_changed")


func _set_constitution(value):
	constitution = value
	emit_signal("attribute_changed")


func _set_intelligence(value):
	intelligence= value
	emit_signal("attribute_changed")


func _set_xp(value):
	xp = value
	emit_signal("xp_changed")
