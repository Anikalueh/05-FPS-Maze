extends KinematicBody

onready var Camera = $Pivot/Camera	

var gravity = -30
var max_speed = 5
var mouse_sensitivity = 0.002
var mouse_range = 1.2

export var score = 200
var controlled = true

var velocity = Vector3()

var id = 0

onready var rc = $Pivot/RayCast
onready var flash = $Pivot/Blaster/Flash

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if controlled and event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)
		rotate_y(-event.relative.x * mouse_sensitivity)

func _physics_process(delta):
	if controlled:
		velocity.y += gravity * delta
		if is_on_floor():
			velocity.y = 0
		var desired_velocity = get_input() * max_speed
		
		velocity.x = desired_velocity.x
		velocity.z = desired_velocity.z
		velocity = move_and_slide(velocity, Vector3.UP, true)
		
		if Input.is_action_pressed("shoot"):	#and !flash.visible
			flash.shoot()
			if rc.is_colliding():
				var c = rc.get_collider()
				if c.is_in_group("Enemy"):
					Global.increase_score(score)
					c.queue_free()
