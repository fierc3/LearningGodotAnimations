extends Node3D

# Variables to reference the AnimationTree and AnimationPlayer
@onready var anim_tree = $AnimationPlayer/AnimationTree
@onready var anim_state_machine: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/StateMachine/playback")

func _ready():
	anim_tree.active = true	

var prevNode = null

func _process(delta):
	var currentNode = anim_state_machine.get_current_node()
		
	if(prevNode == null):
		prevNode = currentNode
		return
		
	if currentNode.begins_with("reload_end"):
		anim_tree["parameters/StateMachine/conditions/reload"] = false
		
	prevNode = currentNode	
	
		
func play_reload_animation(): 
	print("playing ani")
	anim_tree["parameters/StateMachine/conditions/reload"] = true


func _on_shooter_reload_requested():
	play_reload_animation()
