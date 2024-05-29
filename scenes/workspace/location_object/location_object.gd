extends TextureRect

var stats = null
signal damaged
signal updated

func _ready() -> void:
	damaged.connect(_take_damage)
	updated.connect(_update)

	SessionData.workspace_opened.connect(_update)
	var string_size = $Label.get_theme_font("font").get_string_size($Label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, $Label.get_theme_font_size("font_size"))
	$ProgressBar.position.x = string_size.x + 4
	$ProgressBar.size.x = $ProgressBar.size.x - (($ProgressBar.size.x + string_size.x + 4) - size.x)

func _update():
	stats = JSON.parse_string(SessionData.current_location["location_objects"])[get_meta("id", 0)]
	if stats:
		var tex = load("res://cards/textures/location_objects/%s.png" % [stats["texture"]])
		texture = tex
		$ProgressBar.max_value = stats["max_hp"]
		$ProgressBar.value = stats["hp"]
		$Label.text = stats["tag"]
		var string_size = $Label.get_theme_font("font").get_string_size($Label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, $Label.get_theme_font_size("font_size"))
		$ProgressBar.position.x = string_size.x + 4
		$ProgressBar.size.x = $ProgressBar.size.x - ((string_size.x + 4 + $ProgressBar.size.x) - size.x)

func _take_damage(str):
	_update_healthbar($ProgressBar.value, $ProgressBar.value - str)

func _update_healthbar(old_value, new_value):
	var anim: Animation = $ProgressBar/AnimationPlayer.get_animation("damaged")
	anim.track_set_key_value(0, 0, old_value)
	anim.track_set_key_value(0, 1, new_value)
	$ProgressBar/AnimationPlayer.play("damaged")
