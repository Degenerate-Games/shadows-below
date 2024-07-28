extends CharacterBody2D

@export var max_speed: int = 100
@export var acceleration: int = 500
@export_range(0, 8) var total_power: int = 8
var target: Node2D
var red: ColorValue
var green: ColorValue
var blue: ColorValue

var point_light: PointLight2D
var animation_controller: AnimatedSprite2D
var navigation_agent: NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready():
	point_light = $PointLight2D
	animation_controller = $AnimatedSprite2D
	navigation_agent = $NavigationAgent2D
	var power_remaining = total_power
	
	# Initialize the color values
	red = ColorValue.new(floor(randf_range(0, min(power_remaining, 3))), 3)
	power_remaining -= red.value
	green = ColorValue.new(floor(randf_range(0, min(power_remaining, 3))), 3)
	power_remaining -= green.value
	blue = ColorValue.new(min(power_remaining, 3), 3)
	
	# Set the color of the point light
	var color = Color(red.normalize(), green.normalize(), blue.normalize())
	point_light.color = color
	animation_controller.self_modulate = color

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	move_and_slide()
	
func take_damage(damage: int):
	var power_remaining = red.value + green.value + blue.value
	# If damage would kill this enemy, destroy it and spawn a shadow
	if damage > power_remaining:
		var shadow = load("res://scenes/items/shadow.tscn").instantiate()
		shadow.global_position = global_position
		get_parent().add_child(shadow)
		queue_free()
		return
	# Otherwise, subtract the damage from a random color
	var damage_remaining = damage
	var colors = [red, green, blue]
	colors.shuffle()
	for color in colors:
		if damage_remaining > color.value:
			damage_remaining -= color.value
			color.value = 0
		else:
			color.value -= damage_remaining
			damage_remaining = 0
			break
	# Repeat the process if we have damage remaining
	if damage_remaining > 0:
		take_damage(damage_remaining)
	
func set_target(tgt):
	target = tgt
	create_path()

func create_path():
	if not target:
		return
	navigation_agent.target_position = target.global_position

func get_color() -> Color:
	return point_light.color

func set_color(r: ColorValue, g: ColorValue, b: ColorValue):
	red = r
	green = g
	blue = b
	point_light.color = Color(red.normalize(), green.normalize(), blue.normalize())
	animation_controller.self_modulate = point_light.color

func _on_timer_timeout():
	create_path()
