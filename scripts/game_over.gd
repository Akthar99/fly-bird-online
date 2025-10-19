extends Control


signal restart

@onready var score_label: Label = $Panel/VBoxContainer/score_label

func _on_restart_button_pressed() -> void:
	emit_signal("restart")

func set_global_score(score: int) -> void:
	score_label.text = "SCORE " + str(score)
