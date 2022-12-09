extends KinematicBody

var health = 200
onready var nav_agent = $NavigationAgent
onready var player = get_node("/root/Game/Player")
onready var anim_tree = $AnimationTree
onready var anim_play = $AnimationPlayer
onready var animation_mode = anim_tree.get("parameters/playback")
onready var audio = get_node("Spatial/AudioStreamPlayer")


var path = []
var path_node = 0

var speed = 6
var velocity = Vector3()


func _physics_process(_delta):
	if health <= 0:
		animation_mode.travel("Death")
		yield($AnimationPlayer, "animation_finished")
		queue_free()
		audio.play()
		Global.update_score(1)
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_location()
	var new_velocity = (next_location-current_location).normalized() * speed
	
	nav_agent.set_velocity(new_velocity)
			
func update_target_location(target_location):
	nav_agent.set_target_location(target_location)





func _on_NavigationAgent_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	velocity = move_and_slide(velocity,Vector3.UP,true)
