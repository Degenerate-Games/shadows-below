#	Copyright 2024 Degenerate Games
#
#	Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#		http://www.apache.org/licenses/LICENSE-2.0
#
#	Unless required by applicable law or agreed to in writing, software
#	distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.

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
