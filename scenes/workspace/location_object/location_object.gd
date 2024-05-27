extends TextureRect

var stats = null

func _update():
	stats = SessionData.current_location
	if stats:
		var tex = load("res://cards/textures/location_objects/%s.png" % [stats["texture"]])
		texture = tex
		$ProgressBar.value = stats["max_hp"]
		$ProgressBar.value = stats["hp"]
		$Label.text = stats["tag"]
		var x = $Label.get_theme_font("font").get_string_size($Label.text + " ")
		$ProgressBar.position.x = x 

func _ready() -> void:
	var string_size = $Label.get_theme_font("font").get_string_size($Label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, $Label.get_theme_font_size("font_size"))
	$ProgressBar.position.x = string_size.x + 4
	$ProgressBar.size.x = $ProgressBar.size.x - (($ProgressBar.size.x + string_size.x + 4) - size.x)

func take_damage(str):
	$ProgressBar.value = stats["hp"] - str
