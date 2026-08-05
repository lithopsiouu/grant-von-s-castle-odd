class_name Hitbox
extends Area2D

## An [Area3D] that is detected by a [Hurtbox].

@export var damage: int = 10 ## Damage of Hitbox as [int]

func _init() -> void:
	collision_layer = 9
	collision_mask = 10
