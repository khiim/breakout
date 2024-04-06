extends CharacterBody2D

@export var speed : int = 2
@export var max_speed : int = 12

var mouse_captured = false

var accumulated_move : float = 0

func _physics_process(delta):
	var move = Input.get_axis("left", "right") * max_speed
	if (!is_zero_approx(move)):
		move_and_collide(Vector2(move, 0))
		return
	
	if (!mouse_captured):
		return
	
	if (!is_zero_approx(accumulated_move)):
		if (accumulated_move > max_speed):
			accumulated_move = max_speed
		if (accumulated_move < -max_speed):
			accumulated_move = -max_speed
		move_and_collide(Vector2(accumulated_move, 0))
		accumulated_move = 0

func _input(event):
	if event.is_action_pressed("click"):
		mouse_captured = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			print("Capture mouse")
	
	if event.is_action_pressed("ui_cancel"):
		print("release mouse")
		mouse_captured = false
		accumulated_move = 0
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event is InputEventMouseMotion && mouse_captured:
		accumulated_move += event.relative.x * speed
		
		
