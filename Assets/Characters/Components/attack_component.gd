class_name AttackComponent extends Node

## Handles attacks.

@export var character: CharacterBody2D
@export var hitbox: Hitbox
@export var input: PlayerInputComponent
@export var weapon_swinger: WeaponSwinger

var hitbox_shape: CollisionShape2D

var attack_timer: Timer

@export_category("Attack Settings")
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var attack_distance: float = 10.0 ## Distance in pixels the attack reaches.
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var attack_length: float = 0.2 ## Time in seconds the attack can deal damage for.
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var attack_cooldown: float = 0.1 ## Time in seconds before another attack can begin.
@export var continuous: bool = false ## If the attack repeats when the attack button is held.

@export_category("Swing Targets")
@export var attack_target: Node2D
@export var rest_target: Node2D

var _attacking = false

func _ready() -> void:
	if character == null or hitbox == null or input == null:
		printerr(self, ": Component is missing one or more connections!")
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	
	hitbox_shape = hitbox.get_child(0)
	hitbox_shape.disabled = true
	
	_init_attack_timer()

func _init_attack_timer() -> void:
	attack_timer = Timer.new()
	add_child(attack_timer)
	
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_timer_end)
	
	_set_timer(attack_length)

func _set_timer(length: float) -> void:
	length = clampf(length, 0.1, 2.0) # Force length to not be too short or too long
	attack_timer.wait_time = length

func attack() -> void:
	if _attacking == false:
		_attacking = true
		hitbox_shape.disabled = false
		attack_timer.start()
		_animate_swinger()

func _animate_swinger() -> void:
	var atk_pos = character.global_position.direction_to(input.mouse_pos) * attack_distance
	print(atk_pos)
	attack_target.position = atk_pos
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(
		weapon_swinger, "midpoint_bias", 1.0, attack_length
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(
		weapon_swinger, "midpoint_bias", 0.0, attack_cooldown
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_attack_timer_end() -> void:
	hitbox_shape.disabled = true
	
	if attack_timer.wait_time == attack_cooldown: # If cooldown timer finishes
		_set_timer(attack_length)
		_attacking = false
	else: # If attack length timer finishes
		_set_timer(attack_cooldown)
		attack_timer.start()
	
	if input.attack_btn_down and continuous:
		attack()
