extends CharacterState

var input_dir: Vector2 = Vector2.ZERO
@onready var character: CharacterBody2D = self.owner
@onready var sprite: Sprite2D = $"../../Sprite2D"

@onready var movement_component: MovementComponent = %MovementComponent
@onready var dash_component: DashComponent = %DashComponent

func update(_delta: float) -> void:
	input_dir = state_machine.input_dir ## Input direction from [CharacterStateMachine]
	
	movement_component._update(input_dir)
	
	if input_dir.length() == 0:
		state_machine.change_state("idle")
		
	elif Input.is_action_just_pressed("dash") and dash_component.dash_ready == true:
		state_machine.change_state("dashing")
