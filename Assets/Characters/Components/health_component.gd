class_name HealthComponent extends Node

@export var character: CharacterBody2D
@export var health_bar: TextureProgressBar

@export_category("Health Settings")
@export var health = 100

var bar_hide_time: float = 2
var bar_hide_timer: Timer

func _ready() -> void:
	if health_bar == null:
		return
	
	health_bar.value = health
	bar_hide_timer = Timer.new()
	add_child(bar_hide_timer)
	bar_hide_timer.one_shot = true
	bar_hide_timer.wait_time = bar_hide_time
	bar_hide_timer.timeout.connect(_on_hide_timer_timeout)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		take_damage(25)

func take_damage(damage: float) -> void:
	health -= damage
	
	if health_bar != null:
		health_bar.modulate.a = 1.0 # Set health_bar opacity to be visible
		health_bar.value = health
		bar_hide_timer.start()
	
	if health <= 0:
		_die()

func _die() -> void:
	owner.visible = false
	owner.process_mode = Node.PROCESS_MODE_DISABLED

func _on_hide_timer_timeout() -> void:
	if health_bar == null:
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property(health_bar, "modulate:a", 0.0, 0.2)
