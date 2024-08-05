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
	$VBoxContainer/StoryButton.grab_focus()

func _on_story_button_pressed():
	pass # Story Mode not Enabled


func _on_endless_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/endless.tscn")


func _on_sprite_test_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/sprite_test.tscn")

func _on_back_button_pressed():
	get_parent().get_node("VBoxContainer").get_node("StartButton").grab_focus()
	queue_free()

