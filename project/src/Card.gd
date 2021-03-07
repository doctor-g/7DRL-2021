extends Area2D

signal played

export var enabled_bg_color := Color.white
export var disabled_bg_color := Color.darkgray

export var enabled_text_color := Color.darkgray
export var disabled_text_color := Color.lightgray

var title : String
var level := 1

var _playable := false

onready var _background = $Control/Background

func _ready():
	$Control/Title.text = title
	$Control/LevelLabel.text = str(level)


func update_playability(game:Game) -> void:
	_playable = can_play(game)
	_background.color = enabled_bg_color if _playable else disabled_bg_color
	$Control/Title.add_color_override("font_color", enabled_text_color if _playable else disabled_text_color)


func can_play(_game:Game)->bool:
	assert(false, "Subclasses must override this")
	return false
	

func play(_game:Game) -> void:
	assert(false, "Subclasses must override this")


func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and _playable:
		emit_signal("played")


# Utility for subclasses to get a random thing from a structured map of arrays
# such as {1: [ [x], [y] ] }
func _get_random(map):
	var options : Array = map[level]
	return options[randi() % options.size()]
