extends Area2D

signal pressed

var type
var frame setget _set_frame

func pickup(player)->void:
	assert(type!=null, "Type must be set before this")
	type.pickup(player)


func _set_frame(value):
	$Sprite.frame = value


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("pressed")
