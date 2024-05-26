extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SessionData.me:
		$HBoxContainer/VBoxContainer/Nickname.text = SessionData.me["nickname"][0]
		$HBoxContainer/VBoxContainer/Wallet/Gold.text = SessionData.me["wallet"]["gold"]

func _update() -> void:
	if SessionData.me:
		$HBoxContainer/VBoxContainer/Nickname.text = SessionData.me["nickname"][0]
		$HBoxContainer/VBoxContainer/Wallet/Gold.text = SessionData.me["wallet"]["gold"]
