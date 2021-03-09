class_name Game
extends Control

signal ap_changed
signal phase_changed

const PHASES = [ "Build", "Adventure" ]
const BUILD_PHASE = PHASES[0]
const ADVENTURE_PHASE = PHASES[1]

var ap := 0 setget _set_ap

var _phase : String = PHASES[0] setget _set_phase
var _deck = []
var _discard = []
var _hero : HeroPawn

onready var _Card := load("res://src/Card.tscn")

func _ready():
	randomize()
	
	# Initialize UI
	$PlayerInfoPanel.init($Dungeon.hero)
	$PhasePanel.bind_to(self)
	$ShopPanel.bind_to(self)
	$RoomInfoPanel.bind_to($Dungeon)
	
	_hero = $Dungeon.hero
	_hero.connect("hp_changed", self, "_on_Hero_hp_changed")
	
	# Load the cards
	var test = [ "Armor", "Room", "Gold", "Monster", "Weapon",
				 "Armor", "Room", "Gold", "Monster", "Weapon" ]
	for script in test:
		var card = _Card.instance()
		card.set_script(load("res://src/Cards/%sCard.gd" % script))
		_deck.append(card)
	
	_deck.shuffle()
	_draw_hand()


func _on_Hero_hp_changed()->void:
	if _hero.hp <= 0:
		$GameOverPopup.prepare(_hero)
		$GameOverPopup.show_modal(true)


func get_monsters() -> Array:
	return $Dungeon.get_monsters()


func get_items() -> Array:
	return $Dungeon.get_monsters()


func _draw_hand():
	assert($CardPanel.count_cards() == 0, "There should be no cards before drawing a new hand.")
	for _i in range(0,5):
		if _deck.size() == 0:
			_deck = _discard.duplicate()
			_deck.shuffle()
			_discard = []
		var card = _deck.pop_front()
		card.connect("played", self, "_on_Card_played", [card], CONNECT_ONESHOT)
		$CardPanel.add(card)
	_update_cards()


func _on_Card_played(card) -> void:
	card.play(self)
	$CardPanel.remove(card)
	add_to_discard(card)
	

func add_to_discard(card):
	_discard.append(card)


func add_item(item_actor:Actor)->void:
	$Dungeon.add_item(item_actor)
	_update_cards()


func can_add_item()->bool:
	return $Dungeon.can_add_item()


func add_monster(monster)->void:
	$Dungeon.add_monster(monster)
	_update_cards()
	

func can_add_monster()->bool:
	return $Dungeon.can_add_monster()


func _add_to_next_available_slot(parent:Node2D, thing:Node)->void:
	for child in parent.get_children():
		if child.get_child_count() == 0:
			child.add_child(thing)
			return
	assert("Out of slots!")


func _update_cards():
	for card in $CardPanel.get_cards():
		card.update_playability(self)


func _on_CardsDoneButton_pressed():
	# Remove cards from the card panel
	while $CardPanel.count_cards() > 0:
		var child = $CardPanel.get_card(0)
		_set_ap(ap + 1)
		child.disconnect("played", self, "_on_Card_played")
		$CardPanel.remove(child)
		_discard.append(child)
	$CardsDoneButton.disabled = true
	
	$Dungeon.start_adventure_phase()
	
	$ShopPanel.visible = true
	_set_phase(ADVENTURE_PHASE)
	
	
func has_monster():
	return get_monsters().size() > 0


func _on_PhasePanel_done_pressed():
	_finish_action_phase()


func _finish_action_phase()->void:
	_set_ap(0)
	$Dungeon.end_adventure_phase()
	$CardsDoneButton.disabled = false
	$ShopPanel.visible = false
	_draw_hand()
	_set_phase(BUILD_PHASE)


func _set_ap(value):
	ap = value
	emit_signal("ap_changed", ap)


func _set_phase(value):
	assert(PHASES.has(value))
	_phase = value
	emit_signal("phase_changed", _phase)


func _on_Dungeon_replaced():
	_update_cards()


func get_dungeon_level()->int:
	return $Dungeon.get_level()


func _on_Dungeon_exited():
	$Dungeon.reset()
	_finish_action_phase()
