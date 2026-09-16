class_name CollectionArea extends Area2D

## An [Area2D] that can pick up collectibles. 

func _ready() -> void:
	area_entered.connect(_try_collect)

## Attempt to collect the entered area
func _try_collect(area: Area2D) -> void:
	if area.owner.has_method("collect"):
		area.owner.collect(owner)
