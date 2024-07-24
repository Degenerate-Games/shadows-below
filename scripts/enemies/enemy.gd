extends CharacterBody2D

@export var max_speed: int = 100
@export var acceleration: int = 500
@export var total_power: int = 375
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
	red = ColorValue.new(floor(randf_range(0, power_remaining)))
	power_remaining -= red.value
	green = ColorValue.new(floor(randf_range(0, power_remaining)))
	power_remaining -= green.value
	blue = ColorValue.new(power_remaining)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var color = Color(red.normalize(), green.normalize(), blue.normalize())
	point_light.color = color
	animation_controller.self_modulate = color

func _physics_process(delta):
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	move_and_slide()
	
func take_damage(damage: int):
	var power_remaining = red.value + green.value + blue.value
	# If damage would kill this enemy, destroy it
	if damage > power_remaining:
		queue_free()
		return
	# Otherwise, subtract the damage from a random color
	var damage_remaining = damage
	var cmax = max(red.value, green.value, blue.value)
	var colors = [red, green, blue]
	colors.shuffle()
	for color in colors:
		# If this is our highest color skip it unless it is the only color remaining
		if color.value == cmax && color.value != power_remaining:
			break
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

func _on_timer_timeout():
	create_path()
