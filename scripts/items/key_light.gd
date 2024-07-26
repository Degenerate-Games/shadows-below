extends Area2D

@export_range(0, 9) var key_power: int = 3

var red: ColorValue
var green: ColorValue
var blue: ColorValue

var unlocked = false

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
		return

func get_color() -> Color:
	return Color(red.normalize(), green.normalize(), blue.normalize())