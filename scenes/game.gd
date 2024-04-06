extends Node2D

@onready var bricks = %Bricks
@onready var ball = %Ball
@onready var pointsTextLabel : RichTextLabel = %PointsTextLabel
@onready var livesTextLabel : RichTextLabel = %LivesTextLabel
@onready var gameOverTextLabel : RichTextLabel = %GameOverTextLabel
@onready var highScoreTextLabel : RichTextLabel = %HighScoreTextLabel

@export var lives : int = 3

var brick_scene = preload("res://scenes/brick.tscn")

var current_points : int = 0
var current_highscore : int = 0

func _ready():
	var x_diff = 85
	var y_diff = 35
	var x_start = 84
	var y_start = 120	
	
	for i in range(16):
		for j in range(8):
			var pos = Vector2(x_start + x_diff * i, y_start + y_diff * j)
			var hue = (i + j) / 24.0
			var color = Color.from_hsv(hue, 1, 1)
			var brick : Brick = brick_scene.instantiate()
			brick.position = pos
			brick.color = color
			brick.brick_destroyed.connect(_on_brick_destroyed)
			add_child(brick)
	update_points()
	update_lives()
	
	current_highscore = load_highscore()
	update_highscore()

func _on_brick_destroyed(points : int, pos : Vector2):
	current_points += points
	update_points()
	
func update_points():
	pointsTextLabel.clear()
	pointsTextLabel.push_color(Color.SEA_GREEN)
	pointsTextLabel.append_text("Score: ")
	pointsTextLabel.pop()
	pointsTextLabel.push_color(Color.CHARTREUSE)
	pointsTextLabel.append_text(str(current_points))
	pointsTextLabel.pop()
	
func update_lives():
	livesTextLabel.clear()
	livesTextLabel.push_color(Color.SEA_GREEN)
	livesTextLabel.append_text("Lives: ")
	livesTextLabel.pop()
	livesTextLabel.push_color(Color.CHARTREUSE)
	livesTextLabel.append_text(str(lives))
	livesTextLabel.pop()

func update_highscore():
	highScoreTextLabel.clear()
	highScoreTextLabel.push_color(Color.DARK_RED)
	highScoreTextLabel.append_text("High score: ")
	highScoreTextLabel.pop()
	highScoreTextLabel.push_color(Color.CRIMSON)
	highScoreTextLabel.append_text(str(current_highscore))
	highScoreTextLabel.pop()
	

func _on_ball_exited_screen():
	lives -= 1
	update_lives()
	if (lives <= 0):
		game_over()
	else:
		ball.reset_ball()
		
func game_over():
	ball.queue_free()
	if (current_points > current_highscore):
		save_highscore()
		gameOverTextLabel.text = "[rainbow][font_size=70]NEW HIGHSCORE![/font_size][/rainbow]"
	current_highscore = current_points
	gameOverTextLabel.visible = true
	update_highscore()
	
func save_highscore():
	var score = JSON.stringify({ "score": current_points })
	var file = FileAccess.open("user://highscore.json", FileAccess.WRITE)
	file.store_string(score)

func load_highscore():
	if (FileAccess.file_exists("user://highscore.json")):
		var file = FileAccess.open("user://highscore.json", FileAccess.READ)
		var score = JSON.parse_string(file.get_as_text())
		if (score != null):
			return score.score
		else:
			return 0
	return 0
