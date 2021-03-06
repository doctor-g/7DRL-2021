extends Area2D

signal pressed

func pickup(player)->void:
	player.weapon = load("res://src/Weapons/Dagger.gd").new()


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("pressed")
