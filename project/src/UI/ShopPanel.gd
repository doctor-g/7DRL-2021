extends Control

const _CARDS = [ "Weapon", "Armor", "Gold", "Room"]
const _OFFER_SIZE := 2
const _CARD_SCENE := preload("res://src/Card.tscn")

export var chance_of_level_3 := 0.2

var _game : Game

var disabled := true setget _set_disabled

func _ready():
	refresh()


func bind_to(game:Game):
	assert(game!=null)
	_game = game
	_game.connect("focus_changed", self, "_on_focus_changed")


func refresh():
	# Remove all old buttons
	while $ButtonBox.get_child_count() > 0:
		$ButtonBox.remove_child($ButtonBox.get_child(0))
	
	for _i in range(0, _OFFER_SIZE):
		var type_index := randi() % _CARDS.size()
		var type : String = _CARDS[type_index]
		var card = _CARD_SCENE.instance()
		card.set_script(load("res://src/Cards/%sCard.gd" % type))
		card.level = 2 if randf() > chance_of_level_3 else 3
		card.focus = card.level
		card.cost = card.level * 2
		
		var button : CardButton = CardButton.new()
		button.disabled = true
		button.text = "%s %d - Focus Cost: %d" % [card.title, card.level, card.focus]
		button.connect("pressed", self, "_on_Shop_button_pressed", [card])
		button.card = card
		$ButtonBox.add_child(button)


func _on_focus_changed(_focus:int):
	_update_button_disabled_state()


func _on_Shop_button_pressed(card):
	_game.add_to_discard(card)
	_game.focus -= card.focus


func _set_disabled(value):
	disabled = value
	_update_button_disabled_state()


func _update_button_disabled_state():
	for button in $ButtonBox.get_children():
		button.disabled = disabled or _game.focus < button.card.cost


class CardButton extends Button:
	var card
