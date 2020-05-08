extends KinematicBody2D

# physics
var speed = 200
var jump = 600
var gravity = 800
var velocity = Vector2()
var grounded = false

func _ready():
	pass

func _physics_process(delta):
	velocity.x = 0
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
	velocity = move_and_slide(velocity, Vector2.UP)
	# gravity
	velocity.y += gravity * delta
	# jump
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y -= jump
	# sprite direction
	if velocity.x < 0:
		$Sprite.flip_h = true
	elif velocity.x > 0:
		$Sprite.flip_h = false
