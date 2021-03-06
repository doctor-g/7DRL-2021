extends Node2D

onready var _monsters := $Monsters

func _ready():
	# Initialize the global state
	GameState.room = self
	
	# Load the cards
	var card = preload("res://src/Card.tscn").instance()
	card.command = load("res://src/Commands/Goblin.gd").new()
	add_child(card)
	card.position = Vector2(100,100)


func add_monster(monster)->void:
	_monsters.add_child(monster)
	
	
