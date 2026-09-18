class_name MovementComponent extends Node

@export var character: CharacterBody2D
@export var speed: float = 100.0
@export var accel: float = 800
@export var max_input_dir_difference: float = 0.8

## Moves [param character] with [param speed] using [method CharacterBody2D.move_and_slide]
func _update(move_dir: Vector2, delta: float = 0) -> void:
	if character != null:
		
		var vel: Vector2 = character.velocity
		var target_vel: Vector2 = vel.move_toward(move_dir * speed, accel * delta)
		
		
		vel = target_vel
		
		var vel_dir: Vector2 = vel.normalized()
		
		if abs(move_dir - vel_dir).length() > max_input_dir_difference:
			vel = move_dir * speed
		
		character.move_and_slide()
