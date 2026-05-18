extends CharacterBody3D

@export var speed = 5





var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")



@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


@onready var player: CharacterBody3D = %player



func _ready() -> void:
	$holder/AnimationPlayer.play("mixamo_com")
	
	await get_tree().create_timer(1.0).timeout
	
	
	
	_setup_path_timer()

func _physics_process(delta: float) -> void:
	
	
	if not is_on_floor():
		
		
		
		velocity.y -= gravity * delta
		
		
		
	else:
		velocity.y = 0 
		
		

	var next_path_pos = navigation_agent_3d.get_next_path_position()
	
	
	
	var current_pos = global_position
	
	
	
	var dir = (next_path_pos - current_pos).normalized()
	
	velocity.x = dir.x * speed
	
	
	
	velocity.z = dir.z * speed
	
	
	
	if player:
		var target_pos = player.global_position
		
		
		
		target_pos.y = global_position.y 
		
		
		
		$holder.look_at(target_pos, Vector3.UP)
	
	move_and_slide()

func _setup_path_timer() -> void:
	while true:
		
		
		if player:
			
			
			navigation_agent_3d.target_position = player.global_position
			
			
			
		await get_tree().create_timer(0.3).timeout
