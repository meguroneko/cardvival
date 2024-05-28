extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(_update)
	_update()

func _update():
	var data = get_meta("data")
	if not data.has("name"):
		data = SessionData.current_location
		set_meta("data", data)
	if data:
		$HBoxContainer/VBoxContainer/HBoxContainer/Name.text = data["name"]
		$HBoxContainer/VBoxContainer/HBoxContainer/ID.text = "#" + str(data["id"])
		$HBoxContainer/TextureRect.texture = load("res://gui/workspaces/textures/%s/icon.png" % data["location"])
		if data["location"] != "home":
			$HBoxContainer/VBoxContainer/HBoxContainer2.visible = true
			for child in $HBoxContainer/VBoxContainer/HBoxContainer2/Resources.get_children():
				child.queue_free()
			for item in JSON.parse_string(data["location_objects"]):
				var texrect = TextureRect.new()
				texrect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
				texrect.texture = load("res://cards/textures/location_objects/%s.png" % item["texture"])
				$HBoxContainer/VBoxContainer/HBoxContainer2/Resources.add_child(texrect)
		else:
			$HBoxContainer/VBoxContainer/HBoxContainer2.visible = false


func _on_button_button_down() -> void:
	if get_meta("data")["location"] == "home":
		Popups.show("error", "Work in progress", "Coming soon...")
		return;
	var workspace = get_viewport().get_tree().current_scene.get_node("Workspace")
	SessionData.current_location = get_meta("data")
	SessionData.workspace_opened.emit()
	workspace.visible = not workspace.visible
