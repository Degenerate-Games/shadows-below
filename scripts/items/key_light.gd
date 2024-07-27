extends Area2D

@export_range(0, 9) var key_power: int = 3

var red: ColorValue
var green: ColorValue
var blue: ColorValue

var unlocked = false
var spawn_count = 0

signal key_unlocked

# Called when the node enters the scene tree for the first time.
func _ready():
	var power_remaining = key_power
	
	# Initialize the color values
	red = ColorValue.new(floor(randf_range(0, min(power_remaining, 3))), 3)
	power_remaining -= red.value
	green = ColorValue.new(floor(randf_range(0, min(power_remaining, 3))), 3)
	power_remaining -= green.value
	blue = ColorValue.new(min(power_remaining, 3), 3)
	
	# Set the color of the point light
	var color = Color(red.normalize(), green.normalize(), blue.normalize())
	$PointLight2D.color = color
	$Sprite2D.self_modulate = color

func interact():
	var colors = [red, green, blue]
	colors.shuffle()
	for color in colors:
		if color.value > 0:
			color.value -= 1
			break
	var power_remaining = red.value + green.value + blue.value
	if power_remaining == 0:
		$PointLight2D.enabled = false
		unlocked = true
		emit_signal("key_unlocked")
		return

func get_color() -> Color:
	return Color(red.normalize(), green.normalize(), blue.normalize())

func _on_timer_timeout():
	if unlocked:
		return
	spawn_enemy(randi_range(1, min(2, round(spawn_count / 2.0))))
	spawn_count += 1
func spawn_enemy(level: int):
	var enemy: Node2D
	match level:
		1:
			enemy = load("res://scenes/enemies/enemy_a.tscn").instantiate()
		2:
			enemy = load("res://scenes/enemies/enemy_b.tscn").instantiate()
	enemy.global_position = global_position - Vector2(16, 16)
	enemy.max_speed = 25 * (level + 1)
	enemy.acceleration = 500
	enemy.total_power = 2 + ((level - 1) * 3)
	get_parent().add_child(enemy)