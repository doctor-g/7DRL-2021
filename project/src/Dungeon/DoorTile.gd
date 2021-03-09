extends "res://src/Dungeon/DungeonTile.gd"

func _init():
	open()


func open():
	_set_frame(438)
	passable = true


func close():
	_set_frame(539)
	passable = false
