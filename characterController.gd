extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var deteccion: Area2D = $Area2D
var isGrounded:bool
@export var NORMAL_SPEED: float = 200.0
@export var DASH_SPEED: float = 800.0    
@export var DASH_DURATION: float = 0.15
var is_moving:bool = false
var canMove:bool = true
var isX:bool
var target_rotation:float

func _process(delta: float) -> void:
	if not is_moving:
		sprite.play("idle")
	else:
		sprite.play("dash2")
		

func _physics_process(delta: float) -> void:
	if not is_moving or canMove:
		if Input.is_action_just_pressed("dash_right"):
			velocity = Vector2.RIGHT * DASH_SPEED
			is_moving = true
			rotation_degrees = 270
		elif Input.is_action_just_pressed("dash_left"):
			velocity = Vector2.LEFT * DASH_SPEED
			is_moving = true
			rotation_degrees = 90
			
		elif Input.is_action_just_pressed("dash_down"):
			velocity = Vector2.DOWN * DASH_SPEED
			is_moving = true
			rotation_degrees = 0
			
		elif Input.is_action_just_pressed("dash_up"):
			velocity = Vector2.UP * DASH_SPEED
			is_moving = true
			rotation_degrees = 180
	
	move_and_slide()
	if is_moving:
		var collision = get_last_slide_collision()
		
		if collision:
			canMove = true
			is_moving = false
			velocity = Vector2.ZERO  
			
			
		else:
			canMove = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("spikes"):
		
		queue_free()
