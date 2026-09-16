class_name PointManager extends Node

## Handles points and the changing of them.

var _points: int = 0
signal points_changed

func _ready() -> void:
	points_changed.connect(_on_points_changed)

func add_points(value: int) -> void:
	_points += value
	points_changed.emit()

func remove_points(value: int) -> void:
	_points -= value
	points_changed.emit()

func _on_points_changed() -> void:
	print("points: ", str(_points))
