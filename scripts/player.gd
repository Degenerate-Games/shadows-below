extends CharacterBody2D

@export_category("Player Variables")
@export var max_speed: float = 250
@export var acceleration: float = 1500
@export var friction: float = 600

var animation_controller: AnimatedSprite2D
var aura: PointLight2D

var affected_enemies: Array[Node2D]
var affected_interactables: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_controller = $AnimatedSprite2D
	aura = $PointLight2D
	affected_enemies = []
	affected_interactables = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for enemy in affected_enemies:
		var enemy_color = enemy.get_color()
		if enemy_color.r <= aura.color.r and enemy_color.g <= aura.color.g and enemy_color.b <= aura.color.b:
			enemy.take_damage(1)

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

func take_damage(damage: int):
	if not aura:
		return
	var red = aura.color.r
	var green = aura.color.g
	var blue = aura.color.b
	var power_remaining = red.value + green.value + blue.value
	# If damage would kill the player, destroy it
	if damage > power_remaining:
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
	handle_color_change(Color(red.value, green.value, blue.value))
	# TODO:Update the UI to reflect the new color

func _on_interactable_timer_timeout(interactable):
	if interactable.has_method("get_color"):
		var interactable_color = interactable.get_color()
		if interactable_color.r > aura.color.r or interactable_color.g > aura.color.g or interactable_color.b > aura.color.b:
			return
	interactable.interact()

func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		affected_enemies.append(body)

func _on_area_2d_body_exited(body):
	if body in affected_enemies:
		affected_enemies.erase(body)

func _on_area_2d_area_entered(area):
	if area.has_method("interact"):
		area.get_interact_timer().connect("timeout", _on_interactable_timer_timeout.bind(area))
		area.get_interact_timer().start()
		affected_interactables.append(area)

func _on_area_2d_area_exited(area):
	if area in affected_interactables:
		area.get_interact_timer().disconnect("timeout", _on_interactable_timer_timeout.bind(area))
		area.get_interact_timer().stop()
		affected_interactables.erase(area)