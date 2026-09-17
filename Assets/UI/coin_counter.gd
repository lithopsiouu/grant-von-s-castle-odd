extends Control

@onready var label: Label = $Panel/Label

func _ready() -> void:
	_update_label(0)
	PointsManager.points_changed.connect(_update_label)

func _update_label(points: int) -> void:
	label.text = str(points).pad_zeros(6)
