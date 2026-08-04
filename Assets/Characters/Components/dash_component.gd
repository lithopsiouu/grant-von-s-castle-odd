class_name DashComponent extends Node

@export var character: CharacterBody2D
signal dash_finished ## When the initial [b]dash[/b] has finished, this signal is emitted.

@export_category("Dash Settings")
@export_subgroup("Dash Speed")
@export_enum ("Multiply Speed", "Add Speed") var dash_speed_setting: String = "Multiply Speed"
@export var dash_speed: float = 1.2
@export_subgroup("Dash Time")
@export var dash_sustain: float = 0.1 ## Time that the [b]dash[/b] is sustained in seconds.[br]If [code]value[/code] is lesser than [code]1[/code], the dash will instantly begin decaying.
@export var dash_decay: float = 0.4 ## Time that the [b]dash[/b] decays for.
@export var dash_cooldown: float = 0.3 ## Time to wait before [b]dashing[/b] is possible again.

var dash_timer: Timer
var dashing: bool = false
var decaying: bool = false
var dash_ready: bool = true

func _init() -> void:
	dash_sustain = clampi(dash_sustain, 0.01, 2)

func _ready() -> void:
	_init_dash_timer() # Create dash timer.
	if dash_sustain == dash_decay or dash_sustain == dash_cooldown or dash_decay == dash_cooldown:
		printerr("One or more dash timers are equal to each other! ", self, " will not work correctly.")

## Initialize the timer used for dashing. Also connects timer to the [code]_on_dash_end[/code] function
func _init_dash_timer():
	dash_timer = Timer.new()
	add_child(dash_timer)
	dash_timer.one_shot = true
	
	if dash_sustain < 1:
		decaying = true
		dash_timer.wait_time = dash_decay
		dash_timer.timeout.connect(_on_dash_end)
	else:
		dash_timer.wait_time = dash_sustain
		dash_timer.timeout.connect(_on_dash_end)

func _start_dash_decay():
	dash_timer.wait_time = dash_decay
	dash_timer.start()

func _start_dash_cooldown():
	dash_timer.wait_time = dash_cooldown
	dash_timer.start()

## Dash in the direction of [param dash_dir].
func _update(dash_dir: Vector2, move_speed: float) -> void:
	var strength: float = dash_timer.time_left / dash_timer.wait_time ## Strength value calculated by getting time left.
	var move_dir: Vector2 = dash_dir * move_speed
	
	# Start timer if dashing
	if dashing == false and dash_ready == true:
		dash_timer.start()
		dashing = true
		dash_ready = false
	
	match dash_speed_setting:
		
		"Multiply Speed":
			var speed: Vector2 = move_dir * dash_speed
			
			if not decaying:
				character.velocity = speed
				
			else: 
				character.velocity = move_dir + (speed * strength)
			
		"Add Speed":
			var speed: Vector2 = dash_dir * dash_speed
			
			if not decaying:
				character.velocity = move_dir + speed
				
			else: 
				character.velocity = move_dir + (speed * strength)
	
	character.move_and_slide()

## Emit [signal dash_finished] then begin [method _start_dash_decay]
func _on_dash_end():
	if dash_timer.wait_time == dash_sustain:
		decaying = true
		_start_dash_decay()
		
	elif dash_timer.wait_time == dash_decay:
		dash_finished.emit()
		dashing = false
		_start_dash_cooldown()
		
	else:
		dash_ready = true
		
		if dash_sustain < 1:
			decaying = true
			dash_timer.wait_time = dash_decay
		else:
			decaying = false
			dash_timer.wait_time = dash_sustain
