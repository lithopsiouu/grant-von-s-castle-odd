extends CharacterState

var input_dir: Vector2 = Vector2.ZERO
@onready var character: CharacterBody2D = self.owner

@export_category("Speed Settings")
@export var deceleration_speed: float = 1000.0

func enter() -> void:
	pass

func update(_delta: float) -> void:
	input_dir = Input.get_vector("move left", "move right", "move up", "move down")
	
	if input_dir.length() > 0:
		state_machine.change_state("moving")

func _move_character(_delta: float) -> void:
	character.velocity = state_machine._get_velocity_accel_decel_speed(_delta, Vector2.ZERO, character, 0.0, deceleration_speed)
	
	character.move_and_slide()
