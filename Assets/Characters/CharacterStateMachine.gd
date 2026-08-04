class_name CharacterStateMachine extends Node

## Class for a [CharacterStateMachine].

@export var initial_state: CharacterState

var current_state: CharacterState ## Current state the [CharacterStateMachine] is in.
var last_state: CharacterState ## Last state the [CharacterStateMachine] was in.
var states = {} ## All children that are a [CharacterState]

var input_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	for child in get_children():
		if child is CharacterState:
			child.state_machine = self
			states[child.name.to_lower()] = child
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	input_dir = Input.get_vector("move left", "move right","move up","move down")
	
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

## Change the [param current_state] to [param new_state_name]
func change_state(new_state_name: String) -> void:
	var new_state: CharacterState = states.get(new_state_name.to_lower())
	
	assert(new_state, "State not found: " + new_state_name)
	
	if current_state:
		current_state.exit()
	
	last_state = current_state
	
	new_state.enter()
	
	current_state = new_state
	print(str(new_state_name))

## Return a [Vector2] of [member CharacterBody2D.velocity] with [method move_toward] multiplied by [param speed].
func _get_velocity_accel_decel_speed(_delta: float, input_dir: Vector2, body: CharacterBody2D, speed: float, speed_change: float) -> Vector2:
	
	var vect2: Vector2 = Vector2.ZERO
	
	vect2.x = move_toward(body.velocity.x, input_dir.x * speed, _delta * speed)
	vect2.y = move_toward(body.velocity.y, input_dir.y * speed, _delta * speed)
	
	return vect2
