extends Control

signal done_pressed


func bind_to(game):
	game.connect("phase_changed", self, "_on_phase_changed")
	_on_phase_changed(game._phase)


func _on_phase_changed(phase) -> void:
	$AdventureBox.visible = phase == Game.ADVENTURE_PHASE
	$PhaseLabel.text = "Build the Dungeon" if phase == Game.BUILD_PHASE else "Adventure"


func _on_DoneButton_pressed():
	emit_signal("done_pressed")
