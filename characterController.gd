extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var deteccion: Area2D = $Area2D
@onready var input_buffer_timer: Timer = $InputBufferTimer
@export var DASH_SPEED: float = 800.0
@export var dying:bool = false
var is_moving:bool = false
var won:bool = false

var buffered_input: Vector2 = Vector2.ZERO

func _ready() -> void:
	input_buffer_timer.wait_time = 0.15
	input_buffer_timer.timeout.connect(_on_input_buffer_timer_timeout)

func _on_input_buffer_timer_timeout() -> void: 
	buffered_input = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if dying or won:
		return

	var new_input_direction: Vector2 = Vector2.ZERO 
	
	if event.is_action_pressed("dash_right"):
		new_input_direction = Vector2.RIGHT 
	elif event.is_action_pressed("dash_left"):
		new_input_direction = Vector2.LEFT 
	elif event.is_action_pressed("dash_down"):
		new_input_direction = Vector2.DOWN 
	elif event.is_action_pressed("dash_up"):
		new_input_direction = Vector2.UP 

	if new_input_direction != Vector2.ZERO:
		buffered_input = new_input_direction 
		input_buffer_timer.start()


func _process(delta: float) -> void:
	if not is_moving and not dying:
		sprite.play("idle")
	elif is_moving and not dying:
		sprite.play("dash2")
		

func _physics_process(delta: float) -> void:
	if dying or won:
		if is_moving:
			is_moving = false
			velocity = Vector2.ZERO
			move_and_slide()
		return

	if not is_moving and buffered_input != Vector2.ZERO:
		
		velocity = buffered_input * DASH_SPEED
		is_moving = true
		GameManager.play_sfx("movimiento")
		
		if buffered_input == Vector2.RIGHT:
			rotation_degrees = 270
		elif buffered_input == Vector2.LEFT:
			rotation_degrees = 90
		elif buffered_input == Vector2.DOWN:
			rotation_degrees = 0
		elif buffered_input == Vector2.UP:
			rotation_degrees = 180

		buffered_input = Vector2.ZERO
		input_buffer_timer.stop()

	move_and_slide()

	if is_moving:
		var collision = get_last_slide_collision()
		
		if collision:
			is_moving = false
			velocity = Vector2.ZERO

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("spikes"):
		dying = true
		rotation_degrees = 0
		sprite.play("death")
		sprite.animation_finished.connect(eliminar)
		GameManager.play_sfx("muerte")
		GameManager.displayResult(false)
		
		
func eliminar() -> void:
	queue_free()
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("spikes"):
		dying = true
		rotation_degrees = 0
		sprite.play("death")
		sprite.animation_finished.connect(eliminar)
		GameManager.play_sfx("muerte")
		GameManager.displayResult(false)
	if area.is_in_group("win"):
		won = true
		GameManager.displayResult(true)
