extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().paused:
		show()
		$VBoxContainer/ResumeButton.grab_focus()
	else:
		hide()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			show()
			$VBoxContainer/ResumeButton.grab_focus()
		else:
			hide()

func _on_resume_button_pressed():
	get_tree().paused = false
	hide()


func _on_options_button_pressed():
	var options = load("res://scenes/menus/options.tscn").instantiate()
	add_child(options)


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
