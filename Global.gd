extends Node

var timer = 0
var score = 0
var player

func update_score(s):
	score += s
	get_node("/root/Game/UI/Score").text = "Score: " + str(score)
	
func update_time():
	var t_m = floor(timer / 60)
	var t_s = timer % 60
	var t = "Time: %02d" % t_m
	t += ":%02d" % t_s
	get_node("/root/Game/UI/Time").text = t
	


func _input(_event):
	if Input.is_action_just_pressed("quit"):
		print("yo")
		get_tree().quit()
