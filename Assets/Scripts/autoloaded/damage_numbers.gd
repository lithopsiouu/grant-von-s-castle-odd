extends Node

func display_number(value: float, position: Vector2, is_crit: bool = false):
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 5
	number.scale = Vector2.ONE * 0.5
	number.label_settings = LabelSettings.new()
	
	var color = "#FFF"
	if is_crit:
		color = "#B22"
	
	if value == 0:
		color = "#FFF2"
	
	number.label_settings.font_color = color
	number.label_settings.font_size = 18
	number.label_settings.outline_size = 3
	number.label_settings.outline_color = "#000"
	number.label_settings.font = load("res://Assets/UI/Fonts/TripleN.ttf")
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size /2)
	
	var number_jump_height: float = 24
	
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(
		number, "position:y", number.position.y - number_jump_height, 0.25
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD).set_delay(0.25)
	
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).set_delay(0.5)
	
	await tween.finished
	number.queue_free()
