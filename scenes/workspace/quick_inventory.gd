extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory = SessionData.me["inventory"]
	for item in inventory:
		var card = TextureRect.new()
		card.texture = load("res://cards/textures/%ss/%s.png" % [item["type"], item["texture"]])
		$GCardHandLayout.add_child(card)
	$GCardHandLayout.hovered_index = ($GCardHandLayout.get_child_count() -1) /2
