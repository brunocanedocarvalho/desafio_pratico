extends CharacterBody2D

const SPEED = 70.0
const KNOCKBACK_STRENGTH_WALL = 50.0  # Knockback ao colidir com paredes
const KNOCKBACK_STRENGTH_CAR = 1000.0  # Knockback ao colidir com carros
const KNOCKBACK_DECAY = 500.0

var is_control_disabled = false
var knockback_force = Vector2.ZERO
var is_colliding_with_wall = false

var fuel_counter: Label
var timer: Timer
var wall_timer: Timer

func _ready() -> void:
	fuel_counter = $"../Panel/FuelCounter"
	timer = $"../Panel/Timer"
	
	wall_timer = Timer.new()
	wall_timer.wait_time = 3.0
	wall_timer.one_shot = true
	add_child(wall_timer)

	if timer:
		timer.start()

func _process(delta: float) -> void:
	if is_control_disabled:
		_process_knockback(delta)
	else:
		_process_movement()

	move_and_slide()

func _process_movement() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	velocity.y = 0

	_check_wall_collision()

func _check_wall_collision() -> void:
	if is_on_wall() and not is_colliding_with_wall:
		is_control_disabled = true
		is_colliding_with_wall = true

		if position.x < 100:  # Parede esquerda
			knockback_force = Vector2(KNOCKBACK_STRENGTH_WALL, 0)
		else:  # Parede direita
			knockback_force = Vector2(-KNOCKBACK_STRENGTH_WALL, 0)

		# Reduz o combustível ao colidir
		_reduce_fuel(5)

		# Inicia o timer de recuperação após a colisão
		wall_timer.start()

func _process_knockback(delta: float) -> void:
	velocity = knockback_force
	knockback_force = knockback_force.move_toward(Vector2.ZERO, KNOCKBACK_DECAY * delta)

	if wall_timer.time_left == 0:
		is_control_disabled = false
		is_colliding_with_wall = false

func apply_knockback(knockback_direction: Vector2) -> void:
	is_control_disabled = true
	knockback_force = Vector2(knockback_direction.x, 0) * KNOCKBACK_STRENGTH_CAR

func _reduce_fuel(amount: int) -> void:
	# Acessa o painel e reduz o combustível
	var panel = $"../Panel"
	panel.add_fuel(-amount)
