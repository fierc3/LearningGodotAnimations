extends Node

var WEAPON_CAMERA: Camera3D

func start_timer(timeout_function: Callable, time: float = 1.0):
	var timer = get_tree().create_timer(time)
	timer.timeout.connect(timeout_function)
	
signal hit_player(target)
