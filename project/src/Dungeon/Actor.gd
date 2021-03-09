class_name Actor
extends Node2D

signal moved

var dungeon
var attackable := false
var pickupable := false

onready var frame : int = $Sprite.frame setget _set_frame

# Coordinates within the dungeon.
# Maintain these as integers since Vector2 is floats.
var x := 0 setget _set_x
var y := 0 setget _set_y


# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func move_to(x:int,y:int):
	if dungeon.is_passable(x,y):
		_set_x(x)
		_set_y(y)
		emit_signal("moved")


func _set_frame(value):
	frame = value
	$Sprite.frame = value


func _set_x(value):
	x = value
	position.x = x * dungeon.tile_size


func _set_y(value):
	y = value
	position.y = y * dungeon.tile_size
