extends Panel


@export_category("Color Groups")
@export var red_group: Control
@export var green_group: Control
@export var blue_group: Control
@export var available_group: Control

@export_category("Other")
@export var delay_timer: Timer
@export var available_charges: int
@export var max_charges: int = 5

signal color_changed

var red_value: ColorValue = ColorValue.new(1, 3)
var green_value: ColorValue = ColorValue.new(1, 3)
var blue_value: ColorValue = ColorValue.new(1, 3)

# Called when the node enters the scene tree for the first time.
func _ready():
	red_group = get_node("NewUI/AuraDock/Red")
	green_group = get_node("NewUI/AuraDock/Green")
	blue_group = get_node("NewUI/AuraDock/Blue")
	available_group = get_node("NewUI/AuraDock/Available")
	color_changed.emit(get_color())
	available_charges = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	available_charges = clamp(available_charges, 0, max_charges)
	handle_input()
	update_ui()

func update_ui():
	match red_value.value:
		0:
			red_group.get_node("1").visible = false
			red_group.get_node("2").visible = false
			red_group.get_node("3").visible = false
		1:
			red_group.get_node("1").visible = true
			red_group.get_node("2").visible = false
			red_group.get_node("3").visible = false
		2:
			red_group.get_node("1").visible = true
			red_group.get_node("2").visible = true
			red_group.get_node("3").visible = false
		3:
			red_group.get_node("1").visible = true
			red_group.get_node("2").visible = true
			red_group.get_node("3").visible = true

	match green_value.value:
		0:
			green_group.get_node("1").visible = false
			green_group.get_node("2").visible = false
			green_group.get_node("3").visible = false
		1:
			green_group.get_node("1").visible = true
			green_group.get_node("2").visible = false
			green_group.get_node("3").visible = false
		2:
			green_group.get_node("1").visible = true
			green_group.get_node("2").visible = true
			green_group.get_node("3").visible = false
		3:
			green_group.get_node("1").visible = true
			green_group.get_node("2").visible = true
			green_group.get_node("3").visible = true

	match blue_value.value:
		0:
			blue_group.get_node("1").visible = false
			blue_group.get_node("2").visible = false
			blue_group.get_node("3").visible = false
		1:
			blue_group.get_node("1").visible = true
			blue_group.get_node("2").visible = false
			blue_group.get_node("3").visible = false
		2:
			blue_group.get_node("1").visible = true
			blue_group.get_node("2").visible = true
			blue_group.get_node("3").visible = false
		3:
			blue_group.get_node("1").visible = true
			blue_group.get_node("2").visible = true
			blue_group.get_node("3").visible = true

	for i in range(1, max_charges + 1):
		available_group.get_node(str(i)).visible = i <= available_charges

func handle_input():
	if not delay_timer.is_stopped():
		return

	var changed = false
	if Input.is_action_just_pressed("mixing_ui_red"):
		if available_charges > 0 && red_value.value < 3:
			red_value.add(1)
			available_charges -= 1
			changed = true
		elif red_value.value == 3 || available_charges == 0:
			available_charges += red_value.value
			red_value.value = 0
			changed = true
	if Input.is_action_just_pressed("mixing_ui_green"):
		if available_charges > 0 && green_value.value < 3:
			green_value.add(1)
			available_charges -= 1
			changed = true
		elif green_value.value == 3 || available_charges == 0:
			available_charges += green_value.value
			green_value.value = 0
			changed = true
	if Input.is_action_just_pressed("mixing_ui_blue"):
		if available_charges > 0 && blue_value.value < 3:
			blue_value.add(1)
			available_charges -= 1
			changed = true
		elif blue_value.value == 3 || available_charges == 0:
			available_charges += blue_value.value
			blue_value.value = 0
			changed = true
	if Input.is_action_just_pressed("mixing_ui_clear"):
		available_charges += red_value.value + green_value.value + blue_value.value
		red_value.value = 0
		green_value.value = 0
		blue_value.value = 0
		changed = true


	
	if changed:
		delay_timer.start()
		color_changed.emit(get_color())
		for node in get_tree().get_nodes_in_group("aura_powerup"):
			node.modulate = get_color()

func get_color() -> Color:
	return Color(red_value.normalize(), green_value.normalize(), blue_value.normalize())

func get_inverse_color() -> Color:
	return Color(red_value.invert().normalize(), green_value.invert().normalize(), blue_value.invert().normalize())

func _on_shadow_collected():
	available_charges += 1
