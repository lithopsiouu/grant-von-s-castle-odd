class_name MidpointComponent extends Node2D

@export var point_a: CharacterBody2D
@export var point_b: Node2D

@export_category("Midpoint Settings")
@export_range(0.0, 1.0, 0.01, "suffix:%") var midpoint_bias: float = 0.05
@export_enum("Don't use mouse", "Mouse as Point b") var use_mouse: String = "Don't use mouse"

func _ready() -> void:
	match use_mouse:
		"Don't use mouse":
			pass
		"Mouse as Point b":
			point_b = Node2D.new()
			owner.add_child(point_b)
			point_b.global_position = point_b.get_global_mouse_position()

func _process(delta: float) -> void:
	if use_mouse != "Mouse as Point b":
		if point_a == null:
			return
		printerr(self, ": One or more points have not been assigned to MidpointComponent!")
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	
	if use_mouse == "Mouse as Point b": 
		point_b.global_position = point_a.get_global_mouse_position()
	
	var midpoint = point_a.global_position.lerp(point_b.global_position, midpoint_bias)
	
	global_position = midpoint
