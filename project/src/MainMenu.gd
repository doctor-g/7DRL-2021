extends Control

const _Game := preload("res://src/Game.tscn")


func _on_PlayButton_pressed():
	get_tree().change_scene_to(_Game)


func _on_InstructionsButton_pressed():
	$InstructionsPopup.show_modal(true)


func _on_AboutButton_pressed():
	$AboutPopup.show_modal(true)
