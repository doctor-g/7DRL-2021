extends "res://src/Card.gd"

func _init():
	title = "Focus"
	focus = 2


func can_play(_game)->bool:
	return false
