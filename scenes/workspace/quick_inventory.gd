extends HBoxContainer


func _ready() -> void:
	_update()

func _update() -> void:
	var inventory = SessionData.me["inventory"]
	var i = 0
	for item in inventory:
		if item["type"] == "tool":
			var card = load("res://scenes/workspace/quick_inventory/item.tscn").instantiate() as TextureRect
			card.set_meta("data", item)
			$GCardHandLayout.add_child(card)
