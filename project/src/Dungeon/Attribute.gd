class_name Attribute
extends Node

signal changed

var base_value := 0 setget _set_base_value

var modifier := 0 setget _set_modifier

func value() -> int:
	return base_value + modifier


func _set_base_value(value:int)->void:
	base_value = value
	emit_signal("changed")


func _set_modifier(value:int)->void:
	modifier = value
	emit_signal("changed")



