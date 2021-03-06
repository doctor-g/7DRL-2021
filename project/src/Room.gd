extends Node2D

onready var _monsters := $Monsters
onready var _cards := $Cards
onready var _action_bar := $ActionBar

func _ready():
	# Initialize the global state
	GameState.room = self
	




func add_monster(monster)->void:
	_monsters.add_child(monster)
	
	
func _on_DoneButton_pressed():
	_cards.visible = false
	_enable_action_bar()
	

func _enable_action_bar():
	$ActionBar/AttackButton.disabled = false
