extends KinematicBody

onready var Camera = get_node("/root/Game/Player/Pivot/Camera")
onready var anim_tree = $AnimationTree
onready state_machine = anim_tree.get("parameters/playback")

var velocity = Vector3()
var gravity = -9.8
var speed = 0.2
var max_speed = 4
var mouse_sensitivity = 0.002

var is_idle setget set_is_idle, get_is_idle
var is_running setget set_is_running, get_is_running


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(_delta):
	velocity.y += gravity * _delta
	var falling = velocity.y
	velocity.y = 0
	
	var desired_velocity = get_input() * speed
	if desired_velocity.length():
		velocity += desired_velocity
	else:
		velocity *= 0.9
	var current_speed = velocity.length()
	velocity = velocity.normalized() * clamp(current_speed,0,max_speed)
	velocity.y = falling
	$AnimationTree.set("parameters/Idle_Run/blend_amount", current_speed/max_speed)
	
	velocity = move_and_slide(velocity,Vector3.UP,true)
	if Input.is_action_just_pressed("quit"):
		print("yo")
		get_tree().quit()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)



func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir -= Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir -= Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir
