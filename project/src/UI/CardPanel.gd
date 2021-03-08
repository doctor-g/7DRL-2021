extends Control

signal free_monster_added

onready var _free_monster_button := $FreeMonsterButton

func bind_to(game:Game):
	game.connect("monster_added", self, "_on_Game_monster_added", [game])
	game.connect("room_changed", self, "_on_Game_room_changed", [game])


func add(card:Node2D):
	$Cards.add_child(card)
	var count = $Cards.get_child_count()
	for i in range(0,count):
		var x = range_lerp(i, 0, count-1, 0, rect_size.x-150) # Minus card width, that is
		var pos = Vector2(x,0)
		$Cards.get_child(i).position = pos


func get_cards() -> Array:
	var result = []
	for card in $Cards.get_children():
		result.append(card)
	return result


func remove(card:Node2D):
	$Cards.remove_child(card)


func count_cards() -> int:
	return $Cards.get_child_count()


func _on_FreeMonsterButton_pressed():
	emit_signal("free_monster_added")


func _on_Game_monster_added(game:Game):
	_free_monster_button.disabled = game.room.monsters_played == game.room.max_monsters


func _on_Game_room_changed(game:Game):
	_free_monster_button.disabled = game.room.monsters_played == game.room.max_monsters
