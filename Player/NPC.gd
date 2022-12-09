extends KinematicBody

onready var Dialogue = get_node("/root/Game/UI/Dialogue")

var dialogue = [
	"Zombies!!! (Press E to Continue)",
	"Take my Gun and Shoot them Dead! (Press E to Continue)"
	
]

func _ready():
	$AnimationPlayer.play("CrouchIdle")
	Dialogue.connect("finished_dialogue", self, "finished")

func _on_Area_body_entered(_body):
	Dialogue.start_dialogue(dialogue)


func _on_Area_body_exited(_body):
	Dialogue.hide_dialogue()

func finished():
	get_node("/root/Game/Navigation/EnemyContainer").show()
	Global.timer = 120 
	Global.update_time()
	get_node("/root/Game/UI/Timer").start()
