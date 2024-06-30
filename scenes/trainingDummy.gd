extends Node3D

@export var health = 100
@onready var body = $Body/StaticBody3D
@onready var head = $Head/StaticBody3D
@onready var bodyId = body.get_rid()
@onready var headId = head.get_rid()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("hit_player", _hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _hit(target):
	var targetId = target.collider.get_rid()	
	if bodyId == targetId:
		print("bodyshot")
	elif headId == targetId:
		print("headshot")



