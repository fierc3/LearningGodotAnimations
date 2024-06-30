extends Node3D

@export var health = 100
@onready var body = $Body/StaticBody3D
@onready var head = $Head/StaticBody3D
@onready var bodyId = body.get_rid()
@onready var headId = head.get_rid()

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("hit_player", _hit)
	
func _process(delta):
	if dead:
		return
	
	if health < 1:
		dead = true
		displayDeath()

func displayDeath():
	var mesh: MeshInstance3D = $Head
	var current: StandardMaterial3D = mesh.get_surface_override_material(0)
	
	# Later we will have a light for refractions
	#var light: Light3D = indicator.get_child(0)
	#light.light_color = color
	
	current = current.duplicate()
	current.albedo_color = Color(0,0,0)
	mesh.set_surface_override_material(0, current)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _hit(target):
	var targetId = target.collider.get_rid()	
	if bodyId == targetId:
		print("bodyshot")
		health -= 48
	elif headId == targetId:
		health -= 100
		print("headshot")



