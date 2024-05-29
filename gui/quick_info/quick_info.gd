extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SessionData.player_info_updated.connect(_update)
	_update()

func _update() -> void:
	if SessionData.me:
		$HBoxContainer/VBoxContainer/Nickname.text = SessionData.me["nickname"][0]
		$HBoxContainer/VBoxContainer/Wallet/Gold.text = SessionData.me["wallet"]["gold"]
