extends CharacterState

var input_dir: Vector2 = Vector2.ZERO
@onready var character: CharacterBody2D = self.owner

@export_category("Speed Settings")
@export var deceleration_speed: float = 1000.0

func enter() -> void:
	_move_character()

func update(_delta: float) -> void:
	if state_machine.input_dir.length() > 0:
		state_machine.change_state("moving")

func _move_character() -> void:
	character.velocity = Vector2.ZERO
	character.move_and_slide()
