extends Area2D

signal pressed
signal defeated

var level : int
var max_hp : int setget _set_max_hp
var hp : int setget _set_hp
var ac := 10
var damage : String
var frame : int setget _set_frame

func _ready():
	_update_hp_label()


func defeat():
	emit_signal("defeated")


func _update_hp_label():
	$HpLabel.text = "%d/%d" % [hp, max_hp]


func _set_max_hp(value):
	max_hp = value
	_set_hp(value)


func _set_hp(value):
	hp = value if value >= 0 else 0 # The built-in "max" operates on floats
	_update_hp_label()
	if hp <= 0:
		emit_signal("defeated")
		

func _set_frame(new_frame):
	$Sprite.frame = new_frame


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("pressed")
	
