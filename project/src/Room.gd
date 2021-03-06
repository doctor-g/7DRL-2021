extends Node2D


func _ready():
	# Initialize the global state
	GameState.room = self
	
	# Load the cards
	var card = preload("res://src/Card.tscn").instance()
	card.command = load("res://src/Commands/Goblin.gd").new()
	add_child(card)
	card.position = Vector2(100,100)
