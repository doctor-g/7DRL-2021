extends Actor
class_name Pawn

signal defeated
signal hp_changed

var hp : int setget _set_hp
var max_hp : int setget _set_max_hp


func _set_max_hp(value):
	max_hp = value
	_set_hp(value)


func _set_hp(value):
	hp = value if value >= 0 else 0 # The built-in "max" operates on floats
	emit_signal("hp_changed")
	if hp <= 0:
		emit_signal("defeated")
