extends CharacterBody2D

@export_category("Player Variables")
@export var speed: int = 100
@export var velocity_decay: float = 0.8

var animation_controller: AnimatedSprite2D
var aura: PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_controller = $AnimatedSprite2D
	aura = $PointLight2D

func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir:
		velocity = (velocity * 1) + (input_dir * speed * delta)
		# animation_controller.play("walk")
		move_and_slide()

func handle_color_change(color):
	aura.energy = remap(color.r + color.g + color.b, 0.75, 3.0, 4.0, 0.25)
	aura.color = color
	print(aura.color, aura.energy)

func _on_color_mixing_ui_color_changed(color):
	handle_color_change(color)