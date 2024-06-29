extends Node3D

@export var raycast_length: float = 100.0
@export var decay_scene: PackedScene
@onready var anim_tree = $"../AnimationPlayer/AnimationTree"
@onready var anim_state_machine: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/StateMachine/playback")

var gun_node: Node3D
var arms_node: Node3D

# Original positions
var original_arms_position: Vector3
var original_gun_position: Vector3
var previous_position: Vector3
var original_gun_transform: Transform3D
var original_arms_transform: Transform3D

@export var correction: float = 0.42
@export var kickback_swing: float = 1

# Bullets
@export var max_bullets: int = 3;
@export var current_bullets = 3;

# Reference to the player node
@onready var player: CharacterBody3D = get_tree().get_nodes_in_group("player")[0]
@onready var muzzle_flash: GPUParticles3D = $"../gunrig/Node3D/GPUParticles3D"

signal reload_requested
signal current_bullet_changed(count:int)

var fireCooldown = false

func _ready():
	# Get references to the arms and gun nodes
	original_arms_position = $"../arms_root".global_transform.origin
	original_gun_position = $"../gunrig".global_transform.origin
	gun_node = $"../gunrig"
	arms_node = $"../arms_root"
	previous_position = $".".global_position
	original_gun_transform = gun_node.transform
	original_arms_transform = arms_node.transform
	

func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if Input.is_action_just_pressed("reload") and current_bullets != max_bullets:
		print("reload pressed")
		reload_requested.emit()
#		play_reload_animation()

func shoot() -> void:
	
	if fireCooldown:
		print("shooting is on cooldown")
		return
	
	var currentNode = anim_state_machine.get_current_node()
	
	if current_bullets < 1:
		print("no bullets left!!!")
		return
	
	if currentNode.begins_with("reload"):
		print("can't shoot during reload")
		return
	
	fireCooldown = true
	Global.start_timer(resetCooldown, 0.3)
	
		
	print("muzzle")
	print(muzzle_flash)
	muzzle_flash.emitting = true
	kickback()
	
	# Reduce 1 bullet
	current_bullets = current_bullets - 1
	current_bullet_changed.emit(current_bullets)
		
	var ray_origin = self.global_transform.origin
	var ray_direction = -Global.WEAPON_CAMERA.global_transform.basis.z.normalized()
		
	var space_state = get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.new()
	params.from = ray_origin
	params.to = ray_origin + ray_direction * 20
	params.exclude = []
	
	var result = space_state.intersect_ray(params)

	if result:	
		create_decay(result.position, result.normal)

# Function to create decay at the hit location
func create_decay(position: Vector3, normal: Vector3) -> void:
	if decay_scene:
		var decay_instance = decay_scene.instantiate()
		get_tree().root.add_child(decay_instance)
		decay_instance.global_transform.origin = position
		decay_instance.look_at(self.global_position.normalized(), Vector3.UP)

# Function to handle gun kickback effect
func kickback():
	
	#arms.transform.origin.y = original_arms_position.y + kickback_swing
	#gun.transform.origin.y = original_gun_transform_position.y + kickback_swing
	var gunSwing = deg_to_rad(20)
	var armSwing = deg_to_rad(4)
	
	var gun_transform = gun_node.transform.rotated_local(Vector3.LEFT, gunSwing)
	var arm_transform = arms_node.transform.rotated_local(Vector3.LEFT, armSwing)
	arm_transform.origin.z += 0.02
	gun_transform.origin.z -= 0.1
	
	var arm_tween = create_tween()
	var gun_tween = create_tween()
	# kick
	arm_tween.tween_property(arms_node, "transform", arm_transform, 0.02)
	gun_tween.tween_property(gun_node, "transform", gun_transform, 0.03)
	# return
	arm_tween.tween_property(arms_node, "transform", original_arms_transform, 0.2)
	gun_tween.tween_property(gun_node, "transform", original_gun_transform, 0.2)
	#arm_tween.tween_callback(kickback_callback)
	arm_tween.play()

#func kickback_callback():
	#print("callback")
	
func resetCooldown():
	fireCooldown = false


func _on_animation_tree_animation_finished(anim_name):
	var state = anim_state_machine.get_current_node();
	print("state: " + state)
	if state == "reload_end":
		current_bullets = max_bullets
		current_bullet_changed.emit(current_bullets)
		
