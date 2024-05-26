extends Control

var phrases = [":(", "Uh-huh...", "Thanks for the error.", "Okay...", "Well...", "All right, uh."]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect/AnimationPlayer.play("show")
	$MarginContainer/AnimationPlayer.play("opened")
	SessionData.error_opened.emit()
	var title = $MarginContainer/PanelContainer/VBoxContainer/Title
	title.text = get_meta("title", title.text)
	var description = $MarginContainer/PanelContainer/VBoxContainer/Description
	description.text = get_meta("description", description.text)
	$MarginContainer/PanelContainer/VBoxContainer/Button.text = phrases.pick_random()


func _on_button_button_down() -> void:
	SessionData.error_closed.emit()
	$ColorRect/AnimationPlayer.play_backwards("show")
	$MarginContainer/AnimationPlayer.play_backwards("closed")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "closed":
		queue_free()
