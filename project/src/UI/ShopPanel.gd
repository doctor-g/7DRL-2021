extends Control

const _CARDS = [ "Weapon", "Armor", "Monster", "Gold"]

var _game : Game

func _ready():
	var card_scene := preload("res://src/Card.tscn")
	for i in range (0,4):
		var card = card_scene.instance()
		card.set_script(load("res://src/Cards/%sCard.gd" % _CARDS[i]))
		card.level = 2
		
		var button : Button = $HBox.get_child(i)
		button.text = "%s 2 - AP: 4" % card.title
		button.connect("pressed", self, "_on_Shop_button_pressed", [card])
		
	
func bind_to(game:Game)->void:
	_game = game
	game.connect("ap_changed", self, "_on_ap_changed")
	

func _on_ap_changed(ap)->void:
	for child in $HBox.get_children():
		child.disabled = ap < 4


func _on_Shop_button_pressed(card):
	_game.ap -= 4
	_game.add_to_discard(card)
