extends Node2D

const EXAMPLES = [ "1d4", "1d4+4", "1d4-2", "3d6"]

func _ready():
	roll()


func roll():
	for child in $VBoxContainer/Results.get_children():
		$VBoxContainer/Results.remove_child(child)
		
	for example in EXAMPLES:
		var label = Label.new()
		label.text = "%s ==> %d" % [example, Dice.roll(example)]
		$VBoxContainer/Results.add_child(label)


func _on_RollAgainButton_pressed():
	roll()
