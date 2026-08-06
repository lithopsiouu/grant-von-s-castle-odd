extends Node2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var label: Label = $Label

const base_text: String = "[RMB] "
const label_y_offset = 25

var active_areas = [] ## Holds all areas that can currently be interacted with
var can_interact: bool = true


func register_area(area: InteractionArea) -> void:
	active_areas.push_back(area)

func unregister_area(area: InteractionArea) -> void:
	var idx = active_areas.find(area)
	if idx != -1:
		active_areas.remove_at(idx)

func _process(delta: float) -> void:
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= label_y_offset
		label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	
	return area1_to_player < area2_to_player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
