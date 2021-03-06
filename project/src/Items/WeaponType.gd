extends Node

func pickup(player)->void:
	player.weapon = load("res://src/Weapons/Dagger.gd").new()
