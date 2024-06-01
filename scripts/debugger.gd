extends Node3D

class_name Debugger

var debugCube := preload("res://scenes/debug.tscn")
const DEFAULT_COLOR = Color(1, 1, 1)  # White color

func spawn_cube(position: Vector3, parent: Node3D, color: Color = DEFAULT_COLOR):
	# Instance the cube scene
	var cube_instance = debugCube.instantiate()
	print()
	
	# Find the first MeshInstance3D child
	var mesh_instance: MeshInstance3D = null
	for child in cube_instance.get_children():
		if child is MeshInstance3D:
			mesh_instance = child
			break
	# Change the cube's color if a MeshInstance3D is found
	if mesh_instance:
		var material = StandardMaterial3D.new()
		material.albedo_color = color
		mesh_instance.material_override = material
		
	# Set the position of the cube
	cube_instance.transform.origin = position
	
	# Add the cube instance to the scene tree
	parent.get_tree().get_root().add_child(cube_instance)
	return cube_instance
