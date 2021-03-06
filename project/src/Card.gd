extends Node2D

var command 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.text = command.name


func _on_Button_pressed():
	command.execute()
	queue_free()
