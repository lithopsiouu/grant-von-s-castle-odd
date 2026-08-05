class_name Hurtbox
extends Area2D

## An [Area3D] that detects a [Hitbox]. The [Hurtbox] then takes the [Hitbox.damage] and passes it to a
## [code]"take_damage"[/code] owner method.

@onready var hurt_timer: Timer = $"../HurtTimer"
var ignored_areas: Array = [Hitbox] ## Areas that have already been checked.
var current_hitbox: Hitbox = null

@export var health_component: HealthComponent

func _ready() -> void:
	collision_layer = 10
	collision_mask = 9
	area_entered.connect(_on_area_entered)

## See if hurt cooldown is active, and if not, begin cooldown
func hurt_cooldown() -> bool:
	var cooldown_active = false
	if hurt_timer.time_left > 0:
		cooldown_active = true
	else:
		cooldown_active = false
		hurt_timer.start()
	return cooldown_active

func compare_hitbox_rid(hitbox: Hitbox):
	return current_hitbox.get_rid() == hitbox.get_rid()

func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox == null:
		return
	
	current_hitbox = hitbox
	
	if hitbox.owner == owner:
		print("Hitbox owner is same as hurtbox!")
		return
	
	if ignored_areas.find_custom(compare_hitbox_rid.bind()) != -1:
		return
	
	ignored_areas.append(hitbox)
	
	if hurt_cooldown() == true:
		return
	else:
		if health_component != null:
			health_component.take_damage(hitbox.damage)
		else:
			if owner.has_method("take_damage"):
				owner.take_damage(hitbox.damage)
			
			if owner.has_method("do_knockback"):
				owner.do_knockback(owner.global_position)

## Clear all ignored Hitbox elements when [param HurtTimer] ends
func _on_hurt_timer_timeout() -> void:
	ignored_areas.clear()
