extends TextureRect

@onready var sub_viewport = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position = (Vector2(sub_viewport.size) - self.size) / 2
	sub_viewport.connect("size_changed", _on_sub_viewport_size_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_sub_viewport_size_changed():
	self.position = (Vector2(sub_viewport.size) - self.size) / 2
	pass
