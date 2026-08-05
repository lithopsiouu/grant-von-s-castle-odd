class_name Hitbox
extends Area2D

## An [Area3D] that is detected by a [Hurtbox].

@export var damage: float = 10 ## Damage of Hitbox as [float]
@export var continuous_damage: bool = false ## Repeatedly deal damage if [code]true[/code].
@export var damage_repeat_time: float = 0.5 ## Time until damage repeats (used by [Hurtbox]).

func _init() -> void:
	collision_layer = 9
	collision_mask = 10
