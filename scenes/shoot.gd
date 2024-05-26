extends Node3D

@export var raycast_length: float = 100.0
@export var decay_scene: PackedScene

func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot() -> void:
	var ray_origin = self.global_transform.origin
	var ray_direction = self.global_transform.basis.z * raycast_length
	
	var space_state = get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.new()
	params.from = ray_origin
	params.to = ray_direction
	params.exclude = []
	var result = space_state.intersect_ray(params)

	if result:
		print(result.normal)
		print(result.position)
	
		create_decay(result.position, result.normal)

# Function to create decay at the hit location
func create_decay(position: Vector3, normal: Vector3) -> void:
	if decay_scene:
		var decay_instance = decay_scene.instantiate()
		get_tree().root.add_child(decay_instance)
		decay_instance.global_transform.origin = position
		decay_instance.look_at(self.global_position.normalized(), Vector3.UP)
