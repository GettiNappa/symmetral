extends KinematicBody

export var speed = 15
export var acceleration = 10
export var gravity = 4
export var jump_power = 80
export var mouse_sensitivity = 0.3

onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
var camera_x_rotation = 0

var has_double_jumped = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90: 
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	
	var direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += head_basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		direction += head_basis.x
	
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	
	
	if is_on_floor():
		has_double_jumped = false
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_power
		
		
		
	elif Input.is_action_just_pressed("jump") and !is_on_floor() and !has_double_jumped:
		velocity.y += jump_power
		has_double_jumped = true
		
		
		
	
	velocity = move_and_slide(velocity, Vector3.UP)
	




func _on_SafetyNetArea_body_entered(body):
	body.translation = get_parent().get_node("SpawnPoint").get_translation()
