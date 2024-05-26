extends Control

var type = 0
var login_dg = ["Welcome back!", "Hey again!", "Heya!"]
var signup_dg = ["Welcome to the world of cards!", "I'd be happy to meet you!", "Who are you?"]
var adjectives = ["lonely", "silly", "cute", "jolly", "virtual", "strange", "clever", "magical", "confused"]
var nicknames = ["maid", "girl", "cow", "bunny", "cat", "kun", "doomer", "fox"]
var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012345689@#$%*.:_!"
var entered_creds = {"email": null, "password": null}

func _process(delta: float) -> void:
	if not type:
		if $MarginContainer/VBoxContainer/Email.text == "" or $MarginContainer/VBoxContainer/Password.text == "":
			$MarginContainer/VBoxContainer/Auth.disabled = true
		else:
			$MarginContainer/VBoxContainer/Auth.disabled = false
	else:
		if $MarginContainer/VBoxContainer/Email.text == "" or $MarginContainer/VBoxContainer/Password.text == "" or $MarginContainer/VBoxContainer/Nickname.text == "":
			$MarginContainer/VBoxContainer/Auth.disabled = true
		else:
			$MarginContainer/VBoxContainer/Auth.disabled = false

func _ready() -> void:
	$MarginContainer/VBoxContainer/Auth/AnimationPlayer.play("auth")
	$MarginContainer/VBoxContainer/Dialogue.text = login_dg.pick_random()
	var email_example = adjectives.pick_random() + nicknames.pick_random() + str(randi_range(1, 100)) + "@maidverse.lol"
	$MarginContainer/VBoxContainer/Email.placeholder_text = email_example
	var nickname_example = adjectives.pick_random() + nicknames.pick_random()
	$MarginContainer/VBoxContainer/Nickname.placeholder_text = nickname_example
	var password_example = ""
	for i in range(8):
		var random_index = randi() % chars.length()
		password_example += chars.substr(random_index, 1)
	$MarginContainer/VBoxContainer/Password.placeholder_text = password_example
	var file = FileAccess.open("user://account.card", FileAccess.READ)
	if file and file.get_line():
		var line = JSON.parse_string(file.get_as_text())
		if line:
			if line.has("password") and line.has("email"):
				auth(line["email"], line["password"])

func _on_auth_button_down() -> void:
	var nickname = $MarginContainer/VBoxContainer/Nickname.text.uri_encode()
	var email = $MarginContainer/VBoxContainer/Email.text.uri_encode()
	var password = $MarginContainer/VBoxContainer/Password.text.uri_encode()
	auth(email, password, nickname)

func auth(email, password, nickname=null):
	$MarginContainer/VBoxContainer/Auth.disabled = true
	$MarginContainer/VBoxContainer/Auth/AnimationPlayer.play("loading")
	entered_creds["email"] = email
	entered_creds["password"] = password
	if type:
		var sup = {"n": nickname, "e": email, "p": password}
		$HTTPRequest.request(Server.address + "auth/signup?nickname={n}&email={e}&password={p}".format(sup))
	else:
		var lin = {"e": email, "p": password}
		$HTTPRequest.request(Server.address + "auth/login?email={e}&password={p}".format(lin))


func _on_choice_button_down() -> void:
	type = 1 if type == 0 else 0
	if type:
		$MarginContainer/VBoxContainer/Choice.text = "it's not my first time here..."
		$MarginContainer/VBoxContainer/Dialogue.text = signup_dg.pick_random()
		$MarginContainer/VBoxContainer/Nickname.visible = true
		$MarginContainer/VBoxContainer/NicknameL.visible = true
	else:
		$MarginContainer/VBoxContainer/Choice.text = "it's my first time here..."
		$MarginContainer/VBoxContainer/Dialogue.text = login_dg.pick_random()
		$MarginContainer/VBoxContainer/Nickname.visible = false
		$MarginContainer/VBoxContainer/NicknameL.visible = false

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	print("server response: " + str(response))
	SessionData.error_closed.connect(_error_closed)
	SessionData.error_opened.connect(_error_opened)
	if response:
		if not response.has("error"):
			SessionData.me = response["me"]
			SessionData.locations = response["locations"]
			var file = FileAccess.open("user://account.card", FileAccess.WRITE)
			file.store_string(JSON.stringify(entered_creds))
			file.close()
			get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
		else:
			Popups.show("error", null, response["error"])
	else:
		Popups.show("error", null, "no response")

func _error_opened():
	pass

func _error_closed():
	$MarginContainer/VBoxContainer/Auth.disabled = false
	$MarginContainer/VBoxContainer/Auth/AnimationPlayer.play("auth")
