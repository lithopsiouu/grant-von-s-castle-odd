extends Node

@export var interaction_area: InteractionArea
@export var toggled_sprite: Sprite2D

func _ready() -> void:
	if interaction_area == null:
		printerr("No interaction area detected!")
		return
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	toggled_sprite.visible = !toggled_sprite.visible
