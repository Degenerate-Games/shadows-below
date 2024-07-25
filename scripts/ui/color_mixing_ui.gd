extends Panel

var current_panel: PanelContainer

@export_category("Highlight Box Themes")
@export var highlight_box: StyleBox
@export var no_highlight_box: StyleBox

@export_category("Color Panels")
@export var red_panel: PanelContainer
@export var green_panel: PanelContainer
@export var blue_panel: PanelContainer

@export_category("Other")
@export var delay_timer: Timer

signal color_changed

var red_value: ColorValue = ColorValue.new(1, 3)
var green_value: ColorValue = ColorValue.new(1, 3)
var blue_value: ColorValue = ColorValue.new(1, 3)

# Called when the node enters the scene tree for the first time.
func _ready():
	current_panel = red_panel
	color_changed.emit(get_color())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_ui()
	handle_input()

func update_ui():
	red_panel.get_node("./Container/Value").set_text(str(red_value.value))
	green_panel.get_node("./Container/Value").set_text(str(green_value.value))
	blue_panel.get_node("./Container/Value").set_text(str(blue_value.value))

func handle_input():
	var mixing_ui_left = Input.is_action_just_pressed("mixing_ui_left")
	var mixing_ui_right = Input.is_action_just_pressed("mixing_ui_right")
	var mixing_ui_up = Input.is_action_pressed("mixing_ui_up")
	var mixing_ui_down = Input.is_action_pressed("mixing_ui_down")

	var next_panel: PanelContainer = null
	if mixing_ui_left:
		next_panel = current_panel.get_node(current_panel.focus_previous)
		next_panel.remove_theme_stylebox_override("panel")
		next_panel.add_theme_stylebox_override("panel", highlight_box)
		current_panel.remove_theme_stylebox_override("panel")
		current_panel.add_theme_stylebox_override("panel", no_highlight_box)
		current_panel = next_panel
	elif mixing_ui_right:
		next_panel = current_panel.get_node(current_panel.focus_next)
		next_panel.remove_theme_stylebox_override("panel")
		next_panel.add_theme_stylebox_override("panel", highlight_box)
		current_panel.remove_theme_stylebox_override("panel")
		current_panel.add_theme_stylebox_override("panel", no_highlight_box)
		current_panel = next_panel
	
	var delta = 0
	if mixing_ui_up:
		delta = 1
	elif mixing_ui_down:
		delta = -1
	
	if delta != 0 && delay_timer.is_stopped():
		match current_panel:
			red_panel:
				red_value.add(delta)
			green_panel:
				green_value.add(delta)
			blue_panel:
				blue_value.add(delta)
		delay_timer.start()
		color_changed.emit(get_color())

func get_color() -> Color:
	return Color(red_value.normalize(), green_value.normalize(), blue_value.normalize())

func get_inverse_color() -> Color:
	return Color(red_value.invert().normalize(), green_value.invert().normalize(), blue_value.invert().normalize())
