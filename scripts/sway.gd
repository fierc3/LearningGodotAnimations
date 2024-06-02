extends Node3D

# Swing parameters
@export var swing_speed: float = 2.0
@export var swing_amount: float = 0.01
@export var correction: float = 1.0
@export var max_swing_amount = 0.1

# Original positions
var original_arms_position: Vector3
var original_gun_position: Vector3
var original_camera_position: Vector3

# Time variable for swinging
var time: float = 0.0
var previous_position: Vector3

var arms
var gun

# Reference to the player node
@onready var player: CharacterBody3D = get_tree().get_nodes_in_group("player")[0]

func _ready():
	# Get references to the arms and gun nodes
	original_arms_position = $"../arms_root".global_transform.origin
	original_gun_position = $"../gunrig".global_transform.origin

	previous_position = $".".global_position
	arms = $"../arms_root"
	gun = $"../gunrig"

func _physics_process(delta):	
	# Update time
	time += delta
	
   	# Calculate the player's velocity based on current and previous position
	var velocity = player.velocity
	var max_player_speed = 5
	var velocity_summary = abs(velocity.x) + abs(velocity.y) + abs(velocity.z)
	if(velocity_summary < 0.1):
		velocity_summary = 1.1
		swing_speed = 3 # tune this for swing speed
	else:
		swing_speed = 8 # tune this for swing speed
	# Calculate the swinging motion				tune this for spread
	var swing = sin(time * swing_speed) * (velocity_summary/200)
	
	var camera_swing = 0 if velocity_summary <= 1.1 else swing * 10

	# Apply the swinging motion
	arms.transform.origin.x = original_arms_position.x + swing
	gun.transform.origin.x = original_gun_position.x + swing - correction

	# Add swing to camera, should be minimal due to the fact we add spread / inaccuracy via raycast spread
	var final_camera_swing = (camera_swing * camera_swing) * 0.2
	Global.WEAPON_CAMERA.global_transform.origin.y += final_camera_swing * 1.2
	Global.WEAPON_CAMERA.global_transform.origin.x += final_camera_swing 
