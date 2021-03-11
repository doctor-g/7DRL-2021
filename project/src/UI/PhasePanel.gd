extends Control

func bind_to(game):
	game.connect("phase_changed", self, "_on_phase_changed")
	_on_phase_changed(game._phase)


func _on_phase_changed(phase) -> void:
	$PhaseLabel.text = "Build the Dungeon" if phase == Game.BUILD_PHASE else "Adventure"

