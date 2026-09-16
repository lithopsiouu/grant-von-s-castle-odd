extends Node2D

@export var coin: Coin
@export var collect_speed: float = 0.8 ## Multiplier for coin collect speed.
@onready var area: Area2D = $Area2D

var collected: bool = false
var delete_distance: float = 8.0
var frames_to_collect: int = 30

func collect(collector: Node2D) -> void:
	PointsManager.add_points(coin.value)
	area.queue_free()
	
	scale = Vector2(1.3, 1.3)
	await move_to_collector(collector)
	
	queue_free()

func move_to_collector(collector: Node2D) -> void:
	for i in range(frames_to_collect):
		global_position = global_position.move_toward(collector.global_position, i * collect_speed)
		scale -= Vector2(0.07, 0.07)
		scale.clamp(Vector2(0.5, 0.5), Vector2(1.3, 1.3))
		
		if global_position.distance_to(collector.global_position) <= delete_distance:
			return
		
		await get_tree().process_frame
