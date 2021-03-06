extends Node2D

signal defeated

func defeat():
	emit_signal("defeated")
