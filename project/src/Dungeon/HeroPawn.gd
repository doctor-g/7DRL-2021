class_name HeroPawn
extends Pawn

signal equipment_changed
signal took_turn
signal gold_changed
signal xp_changed

var active := false

var weapons : Array = []
var equipped_weapon : WeaponActor = _make_starting_weapon() setget _equip_weapon

var armor : Array = []
var equipped_armor : ArmorActor = _make_starting_armor() setget _equip_armor

var ac : int = 10

var gold : int = 0 setget _set_gold
var xp := 0 setget _set_xp

func _init():
	max_hp = 10
	hp = 10


func _make_starting_armor():
	var rags = preload("res://src/Dungeon/ItemActor.tscn").instance()
	rags.set_script(load("res://src/Dungeon/ArmorActor.gd"))
	rags.ac_bonus = 0
	rags.frame = 85
	rags.name = "Peasant Rags"
	return rags


func _make_starting_weapon():
	var fists = preload("res://src/Dungeon/ItemActor.tscn").instance()
	fists.set_script(load("res://src/Dungeon/WeaponActor.gd"))
	fists.name = "Bare Hands"
	fists.damage = "1d2"
	fists.frame = 89
	return fists

func _process(_delta):
	if not active:
		return
		
	if Input.is_action_just_pressed("pass"):
		emit_signal("took_turn")
		return
	
	var desired_x : int = x
	var desired_y : int = y
	if Input.is_action_just_pressed("move_up"):
		desired_y -= 1
	elif Input.is_action_just_pressed("move_right"):
		desired_x += 1
	elif Input.is_action_just_pressed("move_left"):
		desired_x -= 1
	elif Input.is_action_just_pressed("move_down"):
		desired_y += 1
	elif Input.is_action_just_pressed("move_up_right"):
		desired_x += 1
		desired_y -= 1
	elif Input.is_action_just_pressed("move_down_right"):
		desired_x += 1
		desired_y += 1
	elif Input.is_action_just_pressed("move_down_left"):
		desired_x -= 1
		desired_y += 1
	elif Input.is_action_just_pressed("move_up_left"):
		desired_x -= 1
		desired_y -= 1
	
	if desired_x != x or desired_y != y:
		# First see if we can attack something in that square
		var actors_there : Array = dungeon.get_actors_at(desired_x, desired_y)
		var attacked := false
		for actor in actors_there:
			if actor.attackable:
				_attack(actor)
				attacked = true
				continue
			
		# Otherwise, move there if possible and pick up anything on the floor
		if not attacked:
			move_to(desired_x, desired_y)# Pick up anything that was there
			for actor in actors_there:
				if actor.pickupable:
					_pickup(actor)

		emit_signal("took_turn")


func _attack(pawn:Pawn):
	Log.queue("You attack the %s." % pawn.name)
	if Dice.roll("d20") >= pawn.ac:
		var damage = Dice.roll(equipped_weapon.damage)
		Log.queue("You hit for %d damage!" % damage)
		pawn.hp -= damage
	else:
		Log.queue("You miss.")


func _pickup(actor:Actor):
	dungeon.remove(actor)
	if actor is WeaponActor:
		weapons.append(actor)
		_equip_weapon(actor)
	if actor is ArmorActor:
		armor.append(actor)
		_equip_armor(actor)
	if actor is GoldActor:
		_set_gold(gold + actor.amount)
	Log.queue("You pick up a %s." % actor.name) 


func _equip_weapon(weapon:WeaponActor) -> void:
	equipped_weapon = weapon
	emit_signal("equipment_changed")


func _equip_armor(new_armor:ArmorActor) -> void:
	if equipped_armor != null:
		ac -= equipped_armor.ac_bonus
	equipped_armor = new_armor
	ac += equipped_armor.ac_bonus
	emit_signal("equipment_changed")


func _set_gold(value:int) -> void:
	gold = value
	emit_signal("gold_changed")


func _set_xp(value:int) -> void:
	xp = value
	emit_signal("xp_changed")
