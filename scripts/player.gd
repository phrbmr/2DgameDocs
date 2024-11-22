extends Area2D

signal hit

@export var speed = 400 # Speed of player movement in pixels/sec.
var screen_size


func _ready() -> void:
	#hide()
	screen_size = get_viewport_rect().size # Finds the size of the game window.


func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed # Prevents a faster diagonal movement.
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	$AnimatedSprite2D.flip_v = velocity.y > 0  # If positive y, flips
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0  # If negative x, flips
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"


func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	# Disable the players collision so it won´t be triggered more than once
	# Deferred makes Godot wait until is safe to disable
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
