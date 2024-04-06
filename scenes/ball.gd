class_name Ball
extends CharacterBody2D

signal exited_screen

@export var speed : int = 300
@export var max_speed : int = 1000
@export var speed_increase : int = 10
@export var start_position : Vector2

var is_waiting_to_start : bool = true

func _ready():
	velocity = Vector2(randf_range(-2, 2), randf_range(-5, -2)).normalized() * speed

func _physics_process(delta):

	if is_waiting_to_start && Input.is_action_just_released("click"):
		is_waiting_to_start = false
		
	if is_waiting_to_start:
		return

	var collision = move_and_collide(velocity * delta)
	if collision:
		var hit = collision.get_collider()
		if (hit.is_in_group("paddle")):
			var direction = (position - hit.position).normalized() * speed
			velocity = direction
		else:
			if (hit.is_in_group("brick")):
				hit.damage()
				speed = minf(speed + speed_increase, max_speed)
			velocity = velocity.bounce(collision.get_normal()).normalized() * speed
	
	if position.y > 900:
		print("mouse outside screen")
		exited_screen.emit()
		is_waiting_to_start = true
		

func reset_ball():
	is_waiting_to_start = true
	position = start_position
	velocity = Vector2(randf_range(-2, 2), randf_range(-5, -2)).normalized() * speed
	
