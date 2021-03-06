extends Node

var amount := 100

func pickup(player):
	player.gold += amount
