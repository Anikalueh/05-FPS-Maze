extends Control


func _ready():
	pass

func _physics_process(_delta):
	$Score.text = "Score: " + str(Global.score)
