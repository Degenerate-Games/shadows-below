extends CharacterBody2D

@export_category("Player Variables")
@export var max_speed: float = 250 ## The maximum speed the player can move
@export var acceleration: float = 1500 ## The rate at which the player can speed up
@export var friction: float = 600 ## The rate at which the player slows down
@export var aura_pulse_speeds: Array = [0.5, 1, 1.5, 2, 2.5] ## The speeds at which the aura will pulse
@export_range(0, 4) var aura_pulse_speed_idx: float = 0 ## How many times per second the aura will pulse
@export var max_health: float = 5 ## The maximum health the player can have

var animation_controller: AnimatedSprite2D
var aura: PointLight2D
var aura_pulse_timer: Timer

var affected_enemies: Array[Node2D]
var affected_interactables: Array[Node2D]
var base_aura_energy: float
var health: float
var pulsed: bool

signal shadow_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_controller = $AnimatedSprite2D
	aura = $PointLight2D
	aura_pulse_timer = $AuraPulseTimer
	update_aura_pulse_timer()
	aura_pulse_timer.start()
	base_aura_energy = aura.energy
	affected_enemies = []
	affected_interactables = []
	health = max_health
	pulsed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_aura_strength()
	update_health_bar()

func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir:
		velocity = velocity.move_toward(input_dir.normalized() * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

func handle_color_change(color):
	if not aura or not color:
		return
	aura.energy = remap(color.r + color.g + color.b, 0, 3.0, 0.25, 1)
	aura.color = color

func _on_color_mixing_ui_color_changed(color):
	handle_color_change(color)

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

func damage_enemies():
	for enemy in affected_enemies:
		var enemy_color = enemy.get_color()
		if enemy_color.r <= aura.color.r and enemy_color.g <= aura.color.g and enemy_color.b <= aura.color.b:
			enemy.take_damage(1)

func interact():
	for interactable in affected_interactables:
		var interactable_color = interactable.get_color()
		if interactable_color.r <= aura.color.r and interactable_color.g <= aura.color.g and interactable_color.b <= aura.color.b:
			interactable.interact()

func take_damage(damage: float):
	health -= damage
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func collect(item):
	match item.collectible_type:
		Global.COLLECTIBLE_TYPE.SHADOW:
			handle_shadow_collected(item)
		Global.COLLECTIBLE_TYPE.HEALTH:
			handle_health_collected(item)
		Global.COLLECTIBLE_TYPE.POWERUP:
			handle_powerup_collected(item)

func handle_shadow_collected(_item):
	shadow_collected.emit()
	pass

func handle_health_collected(_item):
	health = min(health + 1, max_health)
	pass

func handle_powerup_collected(_item):
	aura_pulse_speed_idx = clamp(aura_pulse_speed_idx + 1, 0, aura_pulse_speeds.size() - 1)
	update_aura_pulse_timer()
	get_parent().set_aura_pulse_level(aura_pulse_speed_idx)

func update_health_bar():
	get_tree().get_first_node_in_group("health_bar").scale.x = remap(health, 0, max_health, 0, 1)

func update_aura_pulse_timer():
	aura_pulse_timer.wait_time = 1 / aura_pulse_speeds[aura_pulse_speed_idx]

func pulse_aura():
	damage_enemies()
	interact()

func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		affected_enemies.append(body)

func _on_area_2d_body_exited(body):
	if body in affected_enemies:
		affected_enemies.erase(body)

func _on_area_2d_area_entered(area):
	if area.has_method("interact"):
		affected_interactables.append(area)

func _on_area_2d_area_exited(area):
	if area in affected_interactables:
		affected_interactables.erase(area)

func _on_aura_pulse_timer_timeout():
	pulsed = false
