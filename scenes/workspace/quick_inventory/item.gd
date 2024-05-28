extends TextureRect

@onready var data = get_meta("data", null)
@onready var rot = get_node("TextureRect").rotation
@onready var pos = get_node("TextureRect").position
var angle_x_max = 50
var angle_y_max = 50

func _ready() -> void:
	if data:
		$TextureRect.texture = load("res://cards/textures/%ss/%s.png" % [data["type"], data["texture"]])


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion: return
	var mouse_pos = get_local_mouse_position()
	var dif: Vector2 = (position + size) - mouse_pos
	
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	
	$TextureRect.material.set_shader_parameter("x_rot", rot_y)
	$TextureRect.material.set_shader_parameter("y_rot", rot_x)


func _on_texture_rect_mouse_exited() -> void:
	$TextureRect.material.set_shader_parameter("x_rot", 0)
	$TextureRect.material.set_shader_parameter("y_rot", 0)
