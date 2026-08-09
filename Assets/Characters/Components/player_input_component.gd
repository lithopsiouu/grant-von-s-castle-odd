class_name PlayerInputComponent extends Node

## Handles player input and passing it to the referenced [CharacterStateMachine]

@export var state_machine: CharacterStateMachine
@export var attack_component: AttackComponent
@export var weapon_swinger: WeaponSwinger
@export var character: CharacterBody2D

var hitbox_shape: CollisionShape2D

var attack_btn_down: bool = false
var mouse_pos: Vector2

func _ready() -> void:
	if state_machine == null:
		printerr(self, ": No statemachine found!")
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	
	if attack_component == null:
		printerr(self, ": No AttackComponent found!")
		process_mode = Node.PROCESS_MODE_DISABLED
		return

func _process(delta: float) -> void:
	state_machine.input_dir = Input.get_vector("move left", "move right","move up","move down")
	mouse_pos = character.get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack_btn_down = true
		attack_component.attack()
	elif event.is_action_released("attack"):
		weapon_swinger.rotate_to(character.global_position.direction_to(mouse_pos))
		attack_btn_down = false
