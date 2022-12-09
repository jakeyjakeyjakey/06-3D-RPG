extends KinematicBody

onready var Camera = get_node("/root/Game/Player/Pivot/Camera")
onready var aimcast = get_node("/root/Game/Player/Pivot/Camera/AimCast")

onready var anim_tree = $AnimationTree
onready var anim_play = $AnimationPlayer
onready var audio = $AudioStreamPlayer
var state_machine = $AnimationTree.get("parameters/playback")

var velocity = Vector3()
var gravity = -9.8
var speed 
var default_speed = 7
var sprint_speed = 14
var max_speed = 15
var mouse_sensitivity = 0.002
var damage = 200
var health = 100

var is_idle setget set_is_idle, get_is_idle
var is_running setget set_is_running, get_is_running
var is_walking setget set_is_walking, get_is_walking

func set_is_idle(value):
	anim_tree.set("parameters/conditions/is_idle", value)
	
func get_is_idle():
	anim_tree.get("parameters/conditions/is_idle")
	
func set_is_running(value):
	anim_tree.set("parameters/conditions/is_running", value)
	
func get_is_running():
	anim_tree.get("parameters/conditions/is_running")

func set_is_walking(value):
	anim_tree.set("parameters/conditions/is_walking", value)

func get_is_walking():
	anim_tree.get("parameters/conditions/is_walking")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print(state_machine.get_current_node())

func _physics_process(_delta):	
	speed = default_speed
	velocity.y += gravity * _delta
	var falling = velocity.y
	velocity.y = 0
	
	var desired_velocity = get_input() * speed
	if desired_velocity.length():
		velocity = desired_velocity
	else:
		velocity *= 0.9
	var current_speed = velocity.length()
	velocity = velocity.normalized() * clamp(current_speed,0,max_speed)
	velocity.y = falling
	velocity = move_and_slide(velocity,Vector3.UP,true)
	
	if Input.is_action_just_pressed("quit"):
		print("yo")
		get_tree().quit()
	return

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
	return
		



func get_input():
	var input_dir = Vector3()
	self.is_running = false
	self.is_walking = false
	if Input.is_action_pressed("forward"):
		self.is_idle = false
		self.is_walking = true
		input_dir -= Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		self.is_idle = false
		self.is_walking = true
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		self.is_idle = false
		self.is_walking = true
		input_dir -= Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		self.is_idle = false
		self.is_walking = true
		input_dir += Camera.global_transform.basis.x
	if Input.is_action_just_pressed("shoot"):
		self.is_idle = false
		self.is_walking = false
		state_machine.travel("Shoot")
		audio.play()
		print("Bang")
		if aimcast.is_colliding():
			var target = aimcast.get_collider()
			if target.is_in_group("enemy"):
				print("hit enemy")
				target.health -= damage
	if Input.is_action_pressed("shift_run"):
		self.is_idle = false
		self.is_walking = false
		self.is_running = true
		speed = sprint_speed
		
	else:
		self.is_idle = true
	
	input_dir = input_dir.normalized()
	return input_dir
