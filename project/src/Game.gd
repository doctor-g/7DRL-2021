class_name Game
extends Control

signal focus_changed(focus)
signal phase_changed

const PHASES = [ "Build", "Adventure" ]
const BUILD_PHASE = PHASES[0]
const ADVENTURE_PHASE = PHASES[1]

var focus := 0 setget _set_focus

var _phase : String = PHASES[0] setget _set_phase
var _deck = []
var _discard = []
var _hero : HeroPawn

onready var _Card := load("res://src/Card.tscn")

func _ready():
	# Initialize UI
	$PlayerInfoPanel.init($Dungeon.hero)
	$PhasePanel.bind_to(self)
	$RoomInfoPanel.bind_to($Dungeon)
	$ShopPanel.bind_to(self)
	$AdventurePanel.bind_to(self)
	
	_hero = $Dungeon.hero
	_hero.connect("hp_changed", self, "_on_Hero_hp_changed")
	
	# Load the cards
	var test = [ "Armor", "Room", "Gold", "Focus", "Weapon",
				 "Armor", "Room", "Gold", "Focus", "Weapon" ]
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
		card.connect("monsterized", self, "_on_Card_monsterized", [card], CONNECT_ONESHOT)
		$CardPanel.add(card)
	_update_cards()


func _on_Card_played(card) -> void:
	card.play(self)
	$CardPanel.remove(card)
	add_to_discard(card)
	
	
func _on_Card_monsterized(card) -> void:
	$CardPanel.remove(card)
	$Dungeon.add_monster(MonsterFactory.create_monster(card.level))
	add_to_discard(card)
	_update_cards()
	

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
		_set_focus(focus + child.focus)
		child.disconnect("played", self, "_on_Card_played")
		$CardPanel.remove(child)
		_discard.append(child)
	$CardsDoneButton.disabled = true
	
	$Dungeon.start_adventure_phase()
	$CardPanel.visible = false
	$AdventurePanel.visible = true
	$ShopPanel.disabled = false
	_set_phase(ADVENTURE_PHASE)
	
	
func has_monster():
	return get_monsters().size() > 0


func _finish_action_phase()->void:
	_set_focus(0)
	_hero.reset_attribute_modifiers()
	$Dungeon.end_adventure_phase()
	$CardsDoneButton.disabled = false
	$ShopPanel.disabled = true
	$CardPanel.visible = true
	$AdventurePanel.visible = false
	_draw_hand()
	_set_phase(BUILD_PHASE)


func _set_focus(value):
	focus = value
	emit_signal("focus_changed", focus)


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


# When spending focus in the adventure panel, it counts as a turn,
# so activate all the critters.
func _on_AdventurePanel_focus_spent():
	$Dungeon.run_monster_turn()
