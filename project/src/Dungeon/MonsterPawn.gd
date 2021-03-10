class_name MonsterPawn
extends Pawn

var level : int
var ac := 10
var damage : String

func _init():
	attackable = true


func take_turn():
	var hero : Pawn = dungeon.hero
	
	if abs(hero.x-x) <= 1 and abs(hero.y-y) <= 1:
		_attack(hero)
	
	else:
		var direction_x := 0
		var direction_y := 0
		if hero.x > x:
			direction_x += 1
		elif hero.x < x:
			direction_x -= 1
		if hero.y > y:
			direction_y += 1
		elif hero.y < y:
			direction_y -= 1
		
		move_to(x+direction_x, y+direction_y)


func _attack(hero):
	if Dice.roll("d20") >= hero.ac:
		var amount = Dice.roll(damage)
		hero.damage(amount)
		Log.queue("The %s hits you for %d." % [name, amount])
	else:
		Log.queue("The %s misses." % name)
