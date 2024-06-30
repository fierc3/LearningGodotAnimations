extends Node3D

@onready var indicator1: MeshInstance3D = $"../gunrig/Skeleton3D/Malorian/AmmoIndicator"
@onready var indicator2: MeshInstance3D = $"../gunrig/Skeleton3D/Malorian/AmmoIndicator2"
@onready var indicator3: MeshInstance3D = $"../gunrig/Skeleton3D/Malorian/AmmoIndicator3"

var RED = Color("FF0000");
var BLUE = Color("00e5ff")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_shooter_current_bullet_changed(count):
	var empty = 3 - count
	var indicators: Array[MeshInstance3D] = [indicator1, indicator2, indicator3]

	# Change color for filled indicators
	for n in range(0, count):
		changeIndicatorColor(indicators[n], BLUE)

	# Reverse the array for empty indicators
	indicators.reverse()

	# Change color for empty indicators
	for n in range(0, empty):
		changeIndicatorColor(indicators[n], RED)
	
func changeIndicatorColor(indicator: MeshInstance3D, color: Color) -> void:
	var current: StandardMaterial3D = indicator.get_surface_override_material(0)
	var light: Light3D = indicator.get_child(0)
	
	light.light_color = color
	
	current = current.duplicate()
	current.albedo_color = color
	indicator.set_surface_override_material(0, current)
