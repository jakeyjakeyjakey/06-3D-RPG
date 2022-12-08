extends KinematicBody

onready var Dialogue = get_node("/root/Game/UI/Dialogue")

var dialogue = [
	"Welcome bbbbb",
	"Press e"
	
]

func _ready():
	$AnimationPlayer.play("CrouchIdle")
	Dialogue.connect("finished_dialogue", self, "finished")

func _on_Area_body_entered(body):
	Dialogue.start_dialogue(dialogue)


func _on_Area_body_exited(body):
	Dialogue.hide_dialogue()

func finished():
	get_node("/root/Game/EnemyContainer").show()
	Global.timer = 120 
	Global.update_time()
	get_node("/root/Game/UI/Timer").start()
