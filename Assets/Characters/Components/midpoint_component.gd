class_name MidpointComponent extends Node2D

@export var point_a: Node2D
@export var point_b: Node2D

@export_category("Midpoint Settings")
@export_range(0.0, 1.0, 0.01, "suffix:%") var midpoint_bias: float = 0.05
@export_enum("Don't use mouse", "Mouse as Point b") var use_mouse: String = "Don't use mouse"

func _ready() -> void:
	match use_mouse:
		"Don't use mouse":
			if point_a == null or point_b == null:
				printerr(self, ": One or more points have not been assigned to MidpointComponent!")
				process_mode = Node.PROCESS_MODE_DISABLED
				return
		"Mouse as Point b":
			point_b = Node2D.new()
			owner.add_child(point_b)
			point_b.global_position = point_b.get_global_mouse_position()

func _process(delta: float) -> void:
	point_b.global_position = point_a.get_global_mouse_position()
	
	global_position = get_midpoint()

func get_midpoint() -> Vector2:
	var midpoint = point_a.global_position.lerp(point_b.global_position, midpoint_bias)
	return midpoint

func _set_new_point_b(new_node: Node2D) -> void:
	point_b = new_node
