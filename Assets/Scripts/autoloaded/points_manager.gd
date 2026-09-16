extends Control

@onready var cam: Camera2D = get_viewport().get_camera_2d()
@onready var label: Label = $Label

var _points: int = 0

func _ready() -> void:
	update_label()

func add_points(value: int) -> void:
	_points += value
	update_label()

func remove_points(value: int) -> void:
	_points -= value
	update_label()

func update_label() -> void:
	label.text = str(_points)
