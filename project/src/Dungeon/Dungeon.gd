extends Node2D

signal exited    # Emitted when the hero exits the room
signal replaced
signal changed

var hero : Pawn
var room_name :String

var tile_size := 32 # Default tile size scaled by 2

var _DungeonTile = preload("res://src/Dungeon/DungeonTile.tscn")


var _tiles = {}
var _actors = []

var _hero_spawn_point : Array # [x,y], keeping as integers
var _monster_spawn_points : Array = [] # [[x1,y1],[x2,y2],...]
var _item_spawn_points : Array = []
var _door

var _level := 0

const _TUNNEL = {
	"level": 0,
	"name": "Tunnel",
	"tiles": [
		"########",
		"#S  MI D",
		"########",
	]
}

func _ready():
	_load(_TUNNEL)
	
	hero = load("res://src/Dungeon/HeroPawn.tscn").instance()
	hero.connect("moved", self, "_on_Hero_moved")
	hero.connect("took_turn", self, "_on_Hero_took_turn")
	_add(hero, _hero_spawn_point[0], _hero_spawn_point[1])


func start_adventure_phase():
	hero.active = true


func end_adventure_phase():
	hero.active = false


func reset():
	_clear()
	replace(_TUNNEL)

# Replace the current room, keeping its contents, with a new room.
func replace(conf:Dictionary):
	var monsters := get_monsters()
	var items := get_items()
	_clear()
	_load(conf)
	_add(hero, _hero_spawn_point[0], _hero_spawn_point[1])
	for monster in monsters:
		add_monster(monster, false)
	for item in items:
		add_item(item)
	emit_signal("replaced")
	

func _clear():
	for tile in _tiles.values():
		tile.get_parent().remove_child(tile)
	_tiles.clear()
	
	while not _actors.empty():
		var actor = _actors[0]
		remove(actor)
	_hero_spawn_point = []
	_monster_spawn_points = []
	_item_spawn_points = []


func get_level()->int:
	return _level


func _load(conf):
	room_name = conf["name"]
	_level = conf["level"]
	var height = conf["tiles"].size()
	var width = conf["tiles"][0].length()
	for i in range(0,width):
		for j in range(0,height):
			var symbol = conf["tiles"][j][i]
			match symbol:
				"#":
					add_tile(_make_wall(), i, j)
				"D":
					_door = _make_door()
					add_tile(_door, i, j)
				"S":
					_hero_spawn_point = [i,j]
				"M":
					_monster_spawn_points.append([i,j])
				"I":
					_item_spawn_points.append([i,j])


func _on_Hero_took_turn():
	run_monster_turn()
	

func run_monster_turn():
	for actor in _actors:
		if actor.has_method("take_turn"):
			actor.take_turn()
	Log.flush()


func _on_Monster_defeated(monster):
	remove(monster)
	Log.queue("The %s dies." % monster.name)
	
	hero.xp += 1 if monster.level == 0 else monster.level * 5
	
	if count_monsters() == 0:
		_door.open()


func _make_wall()->Node2D:
	var wall = _DungeonTile.instance()
	wall.frame = 16
	return wall
	

func _make_door()->Node2D:
	var door = _DungeonTile.instance()
	door.set_script(load("res://src/Dungeon/DoorTile.gd"))
	return door


func add_tile(tile:Node2D, x:int, y:int)->void:
	add_child(tile)
	var coordinates := Vector2(x,y)
	assert (not _tiles.has(coordinates), "There is already a tile at " + str(coordinates))
	_tiles[coordinates] = tile
	tile.position = coordinates * tile_size


func get_actors_at(x:int, y:int)->Array:
	var result := []
	for actor in _actors:
		if actor.x==x and actor.y==y:
			result.append(actor)
	return result


func is_passable(x:int, y:int) -> bool:
	var vector = Vector2(x,y)
	if _tiles.has(vector):
		return _tiles[vector].passable
	else:
		for actor in _actors:
			if actor.x==x and actor.y==y and actor is MonsterPawn:
				return false
		return true


func can_add_monster() -> bool:
	return not _monster_spawn_points.empty()


# Add at a random spawn point
func add_monster(monster:MonsterPawn, connect_signals = true):
	assert(can_add_monster())
	var position = _monster_spawn_points[0]
	_monster_spawn_points.remove(0)
	_add(monster, position[0], position[1])
	if connect_signals:
		monster.connect("defeated", self, "_on_Monster_defeated", [monster], CONNECT_ONESHOT)
	_door.close()


func count_monsters():
	return get_monsters().size()


func get_monsters()->Array:
	var result = []
	for child in _actors:
		if child is MonsterPawn:
			result.append(child)
	return result


func get_total_monster_levels()->int:
	var total_level := 0
	for monster in get_monsters():
		total_level += monster.level
	return total_level


func count_unused_item_slots()->int:
	return _item_spawn_points.size()
	
	
func count_unused_monster_slots()->int:
	return _monster_spawn_points.size()


func get_items()->Array:
	var result = []
	for child in _actors:
		if child is ItemActor:
			result.append(child)
	return result


func can_add_item()->bool:
	return not _item_spawn_points.empty()


func add_item(item:ItemActor):
	assert(can_add_item())
	var position = _item_spawn_points[0]
	_item_spawn_points.remove(0)
	_add(item, position[0], position[1])


func _add(actor:Actor, x:int, y:int)->void:
	actor.dungeon = self
	actor.x = x
	actor.y = y
	if actor is ItemActor:
		$Items.add_child(actor)
	else:
		$Pawns.add_child(actor)
	_actors.append(actor)
	emit_signal("changed")


func remove(actor:Actor) -> void:
	_actors.remove(_actors.find(actor))
	actor.get_parent().remove_child(actor)
	emit_signal("changed")


func _on_Hero_moved():
	var key = Vector2(hero.x,hero.y)
	if _tiles.has(key) and _tiles[key]==_door:
		emit_signal("exited")
