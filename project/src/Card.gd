extends Control

signal played

var command 
var xp := 0 setget _set_xp

func _ready():
	assert(command!=null, "Command may not be null")
	$Button.text = command.name
	_set_xp(0) # Trigger label update


func update_playability(game:Game) -> void:
	$Button.disabled = not can_play(game)


func can_play(game:Game)->bool:
	return command.can_play(game)
	

func play(game:Game) -> void:
	assert(can_play(game))
	command.execute(game)
	_set_xp(xp+1)


func _set_xp(value):
	xp = value
	$XpLabel.text = "XP: " + str(value)


func _on_Button_pressed():
	emit_signal("played")
