extends Control

signal played

var command 


func _ready():
	assert(command!=null, "Command may not be null")
	$Button.text = command.name


func update_playability(game:Game) -> void:
	$Button.disabled = not can_play(game)


func can_play(game:Game)->bool:
	return command.can_play(game)
	

func play(game:Game) -> void:
	assert(can_play(game))
	command.execute(game)


func _on_Button_pressed():
	emit_signal("played")
