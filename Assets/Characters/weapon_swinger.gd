class_name WeaponSwinger extends MidpointComponent

@export var weaponImage: AtlasTexture
@export_range(-360, 360, 0.15, "suffix:°") var texture_up

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.texture = weaponImage

func _process(delta: float) -> void:
	global_position = get_midpoint()

## Move the weapon between the two points using [param pos].
func move_to(pos: float) -> void:
	pos = clampf(pos, 0, 1.0)
	midpoint_bias = pos

## Rotate weapon sprite to the direction [code]dot[/code] vector.
func rotate_to(dir: Vector2) -> void:
	sprite.rotation_degrees = rad_to_deg(dir.angle()) + texture_up
