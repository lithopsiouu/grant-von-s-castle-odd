class_name MovementComponent extends Node

@export var character: CharacterBody2D
@export var speed: float = 100.0

## Moves [param character] with [param speed] using [method CharacterBody2D.move_and_slide]
func _update(move_dir: Vector2) -> void:
	if character != null:
		owner.velocity = move_dir * speed
		owner.move_and_slide()
