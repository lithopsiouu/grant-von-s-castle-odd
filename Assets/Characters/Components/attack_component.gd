class_name AttackComponent extends Node

## Handles attacks.

@export var character: CharacterBody2D
@export var hitbox: Hitbox
@export var input: PlayerInputComponent

var hitbox_shape: CollisionShape2D

var attack_timer: Timer

@export_category("Attack Settings")
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var attack_length: float = 0.2 ## Time in seconds the attack can deal damage for.
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var attack_cooldown: float = 0.1 ## Time in seconds before another attack can begin.
@export var continuous: bool = false ## If the attack repeats when the attack button is held.

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

func _on_attack_timer_end() -> void:
	hitbox_shape.disabled = true
	print("atk end")
	
	if attack_timer.wait_time == attack_cooldown: # If cooldown timer finishes
		_set_timer(attack_length)
		_attacking = false
	else: # If attack length timer finishes
		_set_timer(attack_cooldown)
		attack_timer.start()
	
	if input.attack_btn_down and continuous:
		attack()
