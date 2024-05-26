extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data = get_meta("data")
	$HBoxContainer/VBoxContainer/Name.text = data["name"]
	$HBoxContainer/VBoxContainer/Info/ID.text = "ID: " + str(data["id"])
	$HBoxContainer/TextureRect.texture = load("res://gui/workspaces/textures/%s/icon.png" % data["location"])
