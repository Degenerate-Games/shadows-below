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

var red_value: int = 20
var green_value: int = 20
var blue_value: int = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	current_panel = red_panel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_ui()
	handle_input()

func update_ui():
	red_panel.get_node("./Container/Value").set_text(str(red_value))
	green_panel.get_node("./Container/Value").set_text(str(green_value))
	blue_panel.get_node("./Container/Value").set_text(str(blue_value))
	pass

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
				red_value = clamp(red_value + delta, 0, 255)
			green_panel:
				green_value = clamp(green_value + delta, 0, 255)
			blue_panel:
				blue_value = clamp(blue_value + delta, 0, 255)
		delay_timer.start()
