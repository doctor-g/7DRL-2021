extends Control


func add(card:Node2D):
	$Cards.add_child(card)
	var count = $Cards.get_child_count()
	for i in range(0,count):
		var x = range_lerp(i, 0, count-1, 0, rect_size.x-150) # Minus card width, that is
		var pos = Vector2(x,0)
		$Cards.get_child(i).position = pos


func get_card(index:int):
	return $Cards.get_child(index)


func get_cards() -> Array:
	var result = []
	for card in $Cards.get_children():
		result.append(card)
	return result


func remove(card:Node2D):
	$Cards.remove_child(card)


func count_cards() -> int:
	return $Cards.get_child_count()
