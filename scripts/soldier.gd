extends CharacterBody3D

@onready var armature = $RootNode
@onready var spring_arm_pivot = $SprintArmPivot
@onready var spring_arm = $SprintArmPivot/SpringArm3D
@onready var animation_tree = $AnimationTree

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LERP_VAL = 0.3

#=================
# Crouch Variables
#=================
const CROUCH_SPEED = 1.5
const CROUCH_HEIGHT = 1.0 
const CROUCH_LERP_SPEED = 0.1
const CROUCH_COOLDOWN = 0.5
var is_crouching = false
var original_height = 0.0
var crouch_height = CROUCH_HEIGHT
var can_crouch = true
var crouch_timer = 0.0
#================

#=================
# Shift Variables
#=================
const SHIFT_MODIFIER = 0.5
var is_shifting = false
#================

const camBehaviour = CameraBehaviour.Follow

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * 0.002)
		spring_arm.rotate_x(-event.relative.y * 0.002)
		var clamperDivider = 2 if camBehaviour == CameraBehaviour.Follow else 4
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/clamperDivider, PI/clamperDivider)
				
	# Crouch Handeling
	if Input.is_action_just_pressed("crouch") and can_crouch:
		if !is_crouching:
			start_crouch()
	if Input.is_action_just_released("crouch") and is_crouching:
		stop_crouch()
	
		# Crouch Handeling
	if Input.is_action_just_pressed("shift"):
		is_shifting = true
	if Input.is_action_just_released("shift"):
		is_shifting = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	Global.WEAPON_CAMERA = $SprintArmPivot/SpringArm3D/WeaponCamera

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	
	var current_speed = CROUCH_SPEED if is_crouching else SPEED
	# slow if holding shift
	current_speed = current_speed * SHIFT_MODIFIER if is_shifting else current_speed
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * current_speed, LERP_VAL)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
	
	if camBehaviour == CameraBehaviour.Follow:
		updateFollowCam()


	var forward = input_dir.y * - 1.
	var sideward = input_dir.x
	var runForwadMomentum = velocity.length() / SPEED * forward
	var runSidewardsMomentum = velocity.length() / SPEED * sideward
	#print("runForwadMomentum %s" % runForwadMomentum)
	#print("runSidewardsMomentum %s" % runSidewardsMomentum)
	var animationBlend = Vector2(runSidewardsMomentum, runForwadMomentum)
	
	animation_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
	animation_tree.set("parameters/BlendSpace2D/blend_position", animationBlend)
	
	move_and_slide()

func updateFollowCam():
	var rotation = spring_arm_pivot.rotation.y + 3.14159
	armature.rotation.y = lerp_angle(armature.rotation.y, rotation , 0.8)
	
func start_crouch():
	is_crouching = true
	var new_transform = spring_arm_pivot.transform
	new_transform.origin.y = -0.8
	spring_arm_pivot.transform = new_transform

	
func stop_crouch():
	is_crouching = false
	var new_transform = spring_arm_pivot.transform
	new_transform.origin.y = 0
	spring_arm_pivot.transform = new_transform

func update_crouch(delta):
	if crouch_timer > 0:
		crouch_timer -= delta
	if crouch_timer <= 0:
		can_crouch = true


enum CameraBehaviour {
	Follow,
	Disconnected
}
