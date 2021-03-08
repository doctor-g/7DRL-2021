extends Node

var _regex := RegEx.new()


func _init():
	_regex.compile("(\\d+)?d(\\d+)([\\+\\-]\\d+)?")


func roll(dice:String) -> int:
	var result := _regex.search(dice)
	
	var number := 1 if result.get_string(1) == "" else int(result.get_string(1))
	var sides := int(result.get_string(2))
	
	var modifier := 0
	if result.get_string(3) != "":
		var expression := result.get_string(3)
		modifier = int(expression.substr(1))
		modifier *= 1 if expression[0]=="+" else -1
	
	var sum := 0
	for _i in range(0,number):
		var roll := randi() % sides + 1
		sum += roll + modifier
	return sum
