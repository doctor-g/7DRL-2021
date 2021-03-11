extends Area2D

signal played
signal monsterized

var title : String
var level := 1
var focus := 1
var cost := 4
var has_threat_requirement := false

var _playable := false

onready var _title_label := $Control/TitleLabel
onready var _focus_label := $Control/FocusLabel
onready var _threat_label := $Control/ThreatLabel


func _ready():
	_title_label.text = "%s %s" % [title, _romanize_level()]
	_focus_label.text = "Focus: %d" % focus
	_threat_label.visible = has_threat_requirement
	_threat_label.text = "Threat Req: %d" % level
	# Now here's a kludge.
	if title=="Focus":
		_threat_label.visible = true
		_threat_label.text = "Unplayable"


func _romanize_level():
	match level:
		1: return "I"
		2: return "II"
		3: return "III"


func update_playability(game:Game) -> void:
	_playable = can_play(game)
	$Control/Unplayable.visible = not _playable
	$Control/Playable.visible = _playable
	$Control/MonsterizeButton.disabled = not game.can_add_monster()


func can_play(_game:Game)->bool:
	assert(false, "Subclasses must override this")
	return false
	

func play(_game:Game) -> void:
	assert(false, "Subclasses must override this")


func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and _playable:
		emit_signal("played")


# Utility for subclasses to get a random thing from a structured map of arrays
# such as {1: [ [x], [y] ] }
func _get_random(map):
	var options : Array = map[level]
	return options[randi() % options.size()]

func _on_MonsterizeButton_pressed():
	emit_signal("monsterized")
