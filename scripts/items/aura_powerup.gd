extends RigidBody2D

@export var collectible_type: Item.ITEM_TYPE = Item.ITEM_TYPE.AURA

func _ready():
	contact_monitor = true
	max_contacts_reported = 5
	modulate = get_tree().get_first_node_in_group("HUD").get_node("ColorMixingUI").get_color()

func _on_body_entered(body):
	if body.has_method("collect"):
		body.collect(self)
		queue_free()

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()
