extends Camera3D
# Reference to player body and hands
@onready var player_body = %RootNode
@onready var weapon_camera = %WeaponRenderer

func _ready():
	# Ensure the camera is not showing the player's body
	player_body.visible = false
	#player_hands.visible = true
	near = 0.1  # Adjust the near clip plane to prevent clipping

func _process(delta):
	sync_weapon_camera()

func sync_weapon_camera():
	weapon_camera.global_transform = global_transform

