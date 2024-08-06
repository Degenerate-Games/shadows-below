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
	red = ColorValue.new(randi_range(0, min(power_remaining, 3)), 3)
	power_remaining -= red.value
	green = ColorValue.new(randi_range(0, min(power_remaining, 3)), 3)
	power_remaining -= green.value
	blue = ColorValue.new(min(power_remaining, 3), 3)
	
	# Set the color of the point light
	var color = Color(red.normalize(), green.normalize(), blue.normalize())
	$PointLight2D.color = color
	$Sprite2D.self_modulate = color

func interact():
	key_power -= 1
	if key_power == 0:
		$PointLight2D.enabled = false
		unlocked = true
		$ExplosiveParticle.emitting = true
		emit_signal("key_unlocked")
		$AudioStreamPlayer.play(0)
		return

func get_color() -> Color:
	return Color(red.normalize(), green.normalize(), blue.normalize())

func _on_timer_timeout():
	if unlocked:
		return
	if spawn_count < 3:
		spawn_enemy(1)
	else:
		var rand = randf()
		if rand < 0.45:
			spawn_enemy(1)
		elif rand < 0.9:
			spawn_enemy(2)
		else:
			spawn_enemy(3)
	spawn_count += 1

func spawn_enemy(level: int):
	var enemy: Node2D
	match level:
		1:
			enemy = load("res://scenes/enemies/enemy_a.tscn").instantiate()
		2:
			enemy = load("res://scenes/enemies/enemy_b.tscn").instantiate()
		3:
			enemy = load("res://scenes/enemies/enemy_c.tscn").instantiate()
	enemy.global_position = global_position - Vector2(16, 16)
	enemy.max_speed = 25 * (level + 1)
	enemy.acceleration = 500
	enemy.total_power = 2 + ((level - 1) * 3)
	get_parent().add_child(enemy)
	enemy.call_deferred("set_color", red, green, blue)
	if enemy.has_method("set_target"):
		enemy.call_deferred("set_target", get_parent().get_parent().get_node("Player"))
