extends Node

func show(popup_name, title, description):
	var popup = load("res://popups/{n}/{n}.tscn".format({"n": popup_name})).instantiate()
	popup.set_meta("title", title)
	popup.set_meta("description", description)
	get_viewport().get_tree().current_scene.add_child(popup)
