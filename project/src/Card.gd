extends Control

signal played

var command 


func _ready():
	assert(command!=null, "Command may not be null")
	$Button.text = command.name


func play(game:Game) -> void:
	command.execute(game)


func _on_Button_pressed():
	emit_signal("played")
