extends Node2D

onready var frame : int = $Sprite.frame setget _set_frame

var passable := false

func _set_frame(value):
	frame = value
	$Sprite.frame = value
