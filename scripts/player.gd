extends CharacterBody3D


@export var SPEED = 7.0
@export var JUMP_VELOCITY = 3.5
@export var gravity = -9.8

@export var sensitivity = 0.004 




@onready var head: Node3D = $head
@onready var camera_3d: Camera3D = $head/Camera3D

@onready var gun: Node3D = $head/Camera3D/gun

@onready var gun_raycast: RayCast3D = $head/Camera3D/gun/RayCast3D
@onready var gun_animation: AnimationPlayer = $head/Camera3D/gun/AnimationPlayer



var bullets_left = 40 
var bullet = preload("res://scenes/area_3d.tscn")

func _ready() -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	
	pass




func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera_3d.rotate_x(-event.relative.y * sensitivity	)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("shoot") and bullets_left > 0:
		if !gun_animation.is_playing():
			gun_animation.play("shoot")
			shoot()

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func shoot():
	
	bullets_left -= 1 
	var bullet_instance =bullet.instantiate()
	bullet_instance.position = gun_raycast.global_position 
	bullet_instance.transform.basis = gun_raycast.global_transform.basis
	get_parent().add_child(bullet_instance)
	
	pass
