extends Decal

@export var lifetime: float = 5.0
@export_range(0.8, 1.2, 0.01) var size_variation: float = 1.0
@export var rotation_variation_degrees: float = 10.0

func _ready() -> void:
	# Randomize size
	var size_random_factor = randf_range(0.8, 1.2)
	size *= size_random_factor
	
	await get_tree().create_timer(lifetime).timeout
	print("decay destryoed")
	queue_free()
