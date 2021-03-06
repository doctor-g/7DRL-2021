extends Area2D

signal pressed
signal defeated

var max_hp := 5
var hp := max_hp setget _set_hp

func _ready():
	_update_hp_label()


func defeat():
	emit_signal("defeated")


func _update_hp_label():
	$HpLabel.text = "%d/%d" % [hp, max_hp]


func _set_hp(value):
	hp = value if value >= 0 else 0 # The built-in "max" operates on floats
	_update_hp_label()
	if hp <= 0:
		emit_signal("defeated")


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("pressed")
	
