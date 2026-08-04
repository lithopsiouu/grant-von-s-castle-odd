extends CharacterState

@onready var character: CharacterBody2D = owner
@onready var sprite: Sprite2D = $"../../Sprite2D"

var direction: Vector2 = Vector2.ZERO

@export_category("State Settings")
@export_enum("Dash to Move Direction", "Dash to Mouse Direction") var dash_direction_setting: String = "Dash to Move Direction"

@onready var dash_component: DashComponent = %DashComponent
@onready var movement_component: MovementComponent = %MovementComponent

func enter() -> void:
	dash_component.dash_finished.connect(_on_dash_finished)
	
	match dash_direction_setting:
		"Dash to Move Direction":
			direction = state_machine.input_dir
		"Dash to Mouse Direction":
			direction = character.global_position.direction_to(character.get_global_mouse_position())

func update(_delta: float) -> void:
	dash_component._update(direction, movement_component.speed)

func _on_dash_finished() -> void:
	if state_machine.input_dir.length() > 0:
		state_machine.change_state("moving")
	else:
		state_machine.change_state("idle")
