extends TextureRect

@onready var data = get_meta("data", null)
@onready var rot = get_node("TextureRect").rotation
@onready var pos = get_node("TextureRect").position
var angle_x_max = 50
var angle_y_max = 50
var location_object: TextureRect = null
var timer = 0
signal mined

func _ready() -> void:
	if data:
		$TextureRect.texture = load("res://cards/textures/%ss/%s.png" % [data["type"], data["texture"]])

func _process(delta: float) -> void:
	if timer > 0 and location_object:
		if $RadialProgress.progress == 0:
			$RadialProgress.progress = timer
			$RadialProgress.max_value = timer
		timer -= delta
		$RadialProgress.progress = timer
		if timer <= 0:
			$RadialProgress.progress = 0
			if location_object.get_node("ProgressBar").value <= 0:
				location_object.updated.emit()
			location_object = null
			mined.emit(self)

func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_released("lmb") and !location_object:
		location_object = _get_nearest(get_location_objects())[0] if get_location_objects() else null
		if location_object:
			_hit()
	if scale.x == 1 and not location_object:
		if not event is InputEventMouseMotion: return
		var mouse_pos = get_local_mouse_position()
		var dif: Vector2 = (position + size) - mouse_pos
		
		var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
		var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
		
		var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
		var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
		
		$TextureRect.material.set_shader_parameter("x_rot", rot_y)
		$TextureRect.material.set_shader_parameter("y_rot", rot_x)
	else:
		$TextureRect.material.set_shader_parameter("x_rot", 0)
		$TextureRect.material.set_shader_parameter("y_rot", 0)


func _on_texture_rect_mouse_exited() -> void:
	$TextureRect.material.set_shader_parameter("x_rot", 0)
	$TextureRect.material.set_shader_parameter("y_rot", 0)

func _hit():
	global_position = location_object.global_position
	var path = "workspaces/workspace/%s/interact/%s?with=%s&token=%s" % [SessionData.current_location["id"], location_object.get_meta("id", 0), get_meta("data")["id"], SessionData.me["token"]]
	$HTTPRequest.request(Server.address + path)

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	print("hitted!")
	if response:
		if response.has("error"):
			return _show_error(response["error"])
		location_object.damaged.emit(get_meta("data")["stats"]["str"])
		timer = response["cooldown"]
		if response.has("location_object"):
			var los = JSON.parse_string(SessionData.current_location["location_objects"])
			los[location_object.get_meta("id", 0)] = response["location_object"]
			SessionData.current_location["location_objects"] = JSON.stringify(los)
			SessionData.workspace_updated.emit()
		SessionData.me = response["user"]
		SessionData.player_info_updated.emit()
	else:
		_show_error("no response")

func _show_error(message) -> void:
	location_object = null
	mined.emit(self)
	Popups.show("error", null, message)

func get_location_objects() -> Array:
	var areas = $Area2D.get_overlapping_areas()
	var location_objects = []
	for area in areas:
		if area.get_parent().has_meta("id"):
			location_objects.append(area.get_parent())
	return location_objects

func _get_nearest(location_objects) -> Array:
	var positions = []
	for lo in location_objects:
		var lo_position = lo.get_node("Area2D/CollisionShape2D").global_position
		var my_position = $Area2D/CollisionShape2D.global_position
		var distance = my_position.distance_to(lo_position)
		positions.append([lo, distance])
	positions.sort()
	return positions[0]
