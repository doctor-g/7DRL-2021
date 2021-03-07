extends Node

signal monsters_played_changed
signal items_played_changed

var max_monsters : int
var max_items : int

var monsters_played := 0 setget _set_monsters_played
var items_played := 0 setget _set_items_played


func _init(_max_monsters:int, _max_items:int).():
	max_monsters = _max_monsters
	max_items = _max_items


func _set_monsters_played(value):
	monsters_played = value
	emit_signal("monsters_played_changed")


func _set_items_played(value):
	items_played = value
	emit_signal("items_played_changed")