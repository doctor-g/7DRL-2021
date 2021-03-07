extends Area2D
tool

signal played

export var enabled_bg_color := Color.white
export var disabled_bg_color := Color.darkgray

export var enabled_text_color := Color.darkgray
export var disabled_text_color := Color.lightgray

var command 

var _playable := false

onready var _background = $Control/Background

func _ready():
	if command == null:
		print("Command should not be null, but maybe you're just testing something.")
		$Control/Title.text = "Test Card"
		$Control/LevelLabel.text = "?"
	else:
		$Control/Title.text = command.name
		$Control/LevelLabel.text = "?" if command.get("level") == null else str(command.get("level"))


func update_playability(game:Game) -> void:
	_playable = can_play(game)
	_background.color = enabled_bg_color if _playable else disabled_bg_color
	$Control/Title.add_color_override("font_color", enabled_text_color if _playable else disabled_text_color)


func can_play(game:Game)->bool:
	return command.can_play(game)
	

func play(game:Game) -> void:
	assert(can_play(game))
	command.execute(game)


func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and _playable:
		emit_signal("played")

