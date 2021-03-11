extends "res://src/Cards/ItemCard.gd"

var _range = {
	1: "2d6",
	2: "4d6",
	3: "6d6"
}

func _init():
	title = "Gold"


func play(game:Game) -> void:
	var item = load("res://src/Dungeon/ItemActor.tscn").instance()
	item.set_script(load("res://src/Dungeon/GoldActor.gd"))
	item.amount = Dice.roll(_range[level])
	item.name = "%d pieces of gold" % item.amount	
	item.frame = 803
	game.add_item(item)
	Log.log("You summon a pile of gold.")
