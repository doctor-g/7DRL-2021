extends Actor
class_name Pawn

signal defeated
signal hp_changed

var hp : int setget _set_hp
var max_hp : int setget _set_max_hp
var temp_hp : int setget _set_temp_hp


func damage(amount:int):
	temp_hp -= amount
	if temp_hp <= 0:
		var overflow = -temp_hp
		temp_hp = 0
		_set_hp(hp - overflow)
	else:
		emit_signal("hp_changed")


func _set_max_hp(value):
	var difference = value - max_hp
	max_hp = value
	_set_hp(hp + difference) # Increase by the amount of change


func _set_hp(value):
	hp = value if value >= 0 else 0 # The built-in "max" operates on floats
	emit_signal("hp_changed")
	if hp <= 0:
		emit_signal("defeated")


func _set_temp_hp(value):
	temp_hp = value
	emit_signal("hp_changed")
