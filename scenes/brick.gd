class_name Brick
extends StaticBody2D

@export var color : Color

signal brick_destroyed(points : int, position: Vector2)

func _ready():
	get_node("Sprite2D").self_modulate = color

func damage():
	brick_destroyed.emit(1, position)
	queue_free()
