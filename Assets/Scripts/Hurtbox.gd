class_name Hurtbox
extends Area2D

## An [Area3D] that detects a [Hitbox]. The [Hurtbox] then takes the [Hitbox.damage] and passes it to a
## [code]"take_damage"[/code] owner method.

var buddha_timer: Timer
var ignored_areas: Array = [Hitbox] ## Areas that have already been checked.
var hurt_timers: Dictionary ## Timers that call the [code]_try_hurt_owner[/code] function.
var current_hitbox: Hitbox = null

@export var health_component: HealthComponent
@export var hurt_cooldown_time: float = 0.1

func _ready() -> void:
	if health_component == null:
		printerr("No health component found!")
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	
	collision_layer = 10
	collision_mask = 9
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	_init_buddha_timer()

func _init_buddha_timer() -> void:
	
	buddha_timer = Timer.new()
	add_child(buddha_timer)
	buddha_timer.one_shot = true
	buddha_timer.wait_time = hurt_cooldown_time
	buddha_timer.timeout.connect(_on_buddha_timer_timeout)

## See if hurt cooldown is active, and if not, begin cooldown
func hurt_cooldown() -> bool:
	var cooldown_active = false
	if buddha_timer.time_left > 0:
		cooldown_active = true
	else:
		cooldown_active = false
		buddha_timer.start()
	return cooldown_active

func compare_hitbox_rid(hitbox: Hitbox):
	return current_hitbox.get_rid() == hitbox.get_rid()

func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox == null:
		return
	
	current_hitbox = hitbox
	
	if hitbox.owner == owner:
		#print("Hitbox owner is same as hurtbox.")
		return
	
	if ignored_areas.find_custom(compare_hitbox_rid.bind()) != -1:
		return
	
	ignored_areas.append(hitbox)
	
	if hurt_cooldown() == true:
		return
	else:
		if hitbox.continuous_damage == false:
			_try_hurt_owner(hitbox)
		else:
			_try_hurt_owner(hitbox)
			
			var timer: Timer = Timer.new()
			_init_new_repeat_hurt_timer(timer, hitbox.damage_repeat_time, hitbox)


## Adds a repeat_hurt_timer and connects to the [code]_try_hurt_owner[/code] function.
func _init_new_repeat_hurt_timer(timer: Timer, wait_time: float, hitbox: Hitbox) -> void:
	add_child(timer)
	timer.wait_time = wait_time
	timer.timeout.connect(_try_hurt_owner.bind(hitbox))
	timer.start()
	
	hurt_timers[hitbox] = timer

## Removes a repeat_hurt_timer and disconnects from the [code]_try_hurt_owner[/code] function.
func _remove_repeat_hurt_timer(hitbox: Hitbox) -> void:
	var timer: Timer = hurt_timers.get(hitbox)
	timer.timeout.disconnect(_try_hurt_owner.bind(hitbox))
	remove_child(timer)


func _on_area_exited(hitbox: Hitbox) -> void:
	ignored_areas.erase(hitbox)
	
	if hitbox.continuous_damage:
		_remove_repeat_hurt_timer(hitbox)

func _try_hurt_owner(hitbox: Hitbox) -> void:
	DamageNumbers.display_number(hitbox.damage, hitbox.global_position)
	
	if health_component != null:
		health_component.take_damage(hitbox.damage)
		
	else:
		if owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage)
		
		if owner.has_method("do_knockback"):
			owner.do_knockback(owner.global_position)
	

## Clear all ignored Hitbox elements when [param HurtTimer] ends
func _on_buddha_timer_timeout() -> void:
	ignored_areas.clear()
