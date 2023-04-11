extends Area

export var score = 100

func _on_key_body_entered(body):
	if body.name == "Player":
		Global.increase_score(score)
		var exit = get_node_or_null("/root/Game/Maze/Exit")
		if exit != null:
			var sound = get_node_or_null("/root/Game/Key")
			if sound != null:
				sound.playing = true
			exit.unlock()
			queue_free()
