extends Node

func _input(_event):
	if Input.is_action_just_pressed("quit"):
		print("yo")
		get_tree().quit()
