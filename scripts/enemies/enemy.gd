extends CharacterBody2D

@export var max_speed: int = 100
@export var acceleration: int = 500
@export_range(0, 8) var total_power: int = 8
var target: Node2D
var red: ColorValue
var green: ColorValue
var blue: ColorValue
var base_aura_energy: float
var pulsed: bool
var touching_player: bool

var aura: PointLight2D
var aura_pulse_timer: Timer
var animation_controller: AnimatedSprite2D
var navigation_agent: NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pulsed = false
	touching_player = false
	aura = $PointLight2D
	base_aura_energy = aura.energy
	aura_pulse_timer = $AuraPulseTimer
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
	aura.color = color
	animation_controller.self_modulate = color

func _process(_delta):
	update_aura_strength()

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
	return aura.color

func set_color(r: ColorValue, g: ColorValue, b: ColorValue):
	red = r
	green = g
	blue = b
	aura.color = Color(red.normalize(), green.normalize(), blue.normalize())
	animation_controller.self_modulate = aura.color

func update_aura_strength():
	if not aura:
		return
	var timer_percentage = aura_pulse_timer.time_left / aura_pulse_timer.wait_time
	timer_percentage = remap(timer_percentage, 1, 0, -1, .1)
	var f_a = 1 / pow(timer_percentage, 2)
	var f_b = -1000 * pow(timer_percentage + .1, 2) + 40
	var pulse = f_a
	if timer_percentage >= -0.168192:
		pulse = f_b
	pulse = remap(pulse, 0, 40, 0.25, 1.25)
	if timer_percentage > -0.1 and not pulsed:
		pulsed = true
		pulse_aura()
	aura.energy = base_aura_energy * pulse

func pulse_aura():
	damage_player()

func damage_player():
	if not touching_player:
		return
	get_tree().call_group("player", "take_damage", 0.25)

func _on_timer_timeout():
	create_path()


func _on_aura_pulse_timer_timeout():
	pulsed = false


func _on_area_2d_body_entered(body:Node2D):
	if body.is_in_group("player"):
		touching_player = true


func _on_area_2d_body_exited(body:Node2D):
	if body.is_in_group("player"):
		touching_player = false
