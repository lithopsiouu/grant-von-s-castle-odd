extends Node2D

@export var coin_module: Coin

func collect() -> void:
	PointManager.add_points(coin_module.value)
	queue_free()
