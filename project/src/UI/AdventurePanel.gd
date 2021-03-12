extends Control

signal focus_spent

var _game : Game

onready var _focus_label := $VBox/FocusLabel
onready var _strength_button := $VBox/StrengthButton
onready var _dexterity_button :=  $VBox/DexterityButton
onready var _constitution_button := $VBox/ConstitutionButton
onready var _buttons = [_strength_button, _dexterity_button, _constitution_button]


func bind_to(game:Game)->void:
	_game = game
	game.connect("focus_changed", self, "_on_focus_changed")
	

func _on_focus_changed(focus:int):
	_focus_label.text = "Focus: %d" % focus
	for button in _buttons:
		button.disabled = focus < 2
	


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
