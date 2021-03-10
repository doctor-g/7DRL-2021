extends Control

signal focus_spent

var _game : Game

onready var _strength_button := $VBox/HBox/StrengthButton
onready var _dexterity_button :=  $VBox/HBox/DexterityButton
onready var _constitution_button := $VBox/HBox/ConstitutionButton


func bind_to(game:Game)->void:
	_game = game
	game.connect("focus_changed", self, "_on_focus_changed")
	

func _on_focus_changed(focus:int):
	$VBox/FocusLabel.text = "Focus: %d" % focus
	_strength_button.disabled = focus < 2
	_dexterity_button.disabled = focus < 2


func _on_StrengthButton_pressed():
	_game.focus -= 2
	_game._hero.strength.modifier += 2
	emit_signal("focus_spent")


func _on_DexterityButton_pressed():
	_game.focus -= 2
	_game._hero.dexterity.modifier += 2
	emit_signal("focus_spent")


func _on_ConstitutionButton_pressed():
	_game.focus -= 2
	_game._hero.temp_hp += 2
	emit_signal("focus_spent")
