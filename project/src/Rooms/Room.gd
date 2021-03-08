extends Node

signal monsters_played_changed
signal items_played_changed
signal stable_turns_changed

var max_monsters : int
var max_items : int

var monsters_played := 0 setget _set_monsters_played
var items_played := 0 setget _set_items_played

# This is required in order to only allow higher-level rooms to be played
# over lower ones.
var level : int = 0

# How much damage you take from the room collapsing
var damage : String = "1d2"

var stable_turns := 1 setget _set_stable_turns


func _init(_max_monsters:int, _max_items:int).():
	max_monsters = _max_monsters
	max_items = _max_items


func _set_monsters_played(value):
	monsters_played = value
	emit_signal("monsters_played_changed")


func _set_items_played(value):
	items_played = value
	emit_signal("items_played_changed")


func _set_stable_turns(value):
	stable_turns = value if value >= 0 else 0
	emit_signal("stable_turns_changed")


func create_free_monster():
	var monster = load("res://src/Monsters/Monster.tscn").instance()
	monster.name = "Rat"
	monster.level = 0
	monster.max_hp = 1
	monster.damage = 1
	monster.ac = 10
	monster.frame = 415
	return monster
