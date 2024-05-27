extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SessionData.locations:
		var i = 0
		while i <= len(SessionData.locations) - 1:
			var workspace_portal = null
			if i == 0:
				workspace_portal = load("res://gui/workspaces/workspace_up.tscn").instantiate()
			elif i == len(SessionData.locations) - 1:
				workspace_portal = load("res://gui/workspaces/workspace_down.tscn").instantiate()
			else:
				workspace_portal = load("res://gui/workspaces/workspace_center.tscn").instantiate()
			workspace_portal.set_meta("data", SessionData.locations[i])
			add_child(workspace_portal)
			i += 1
